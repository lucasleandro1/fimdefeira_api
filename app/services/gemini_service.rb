require "httparty"

class GeminiService
  include HTTParty

  def initialize(image_file)
    @image_file = image_file
    @prompt = ENV["PROMPT"]
    @api_key = ENV["GEMINI_API_KEY"]
  end

  def extract_product_data
    upload_url = start_resumable_upload
    unless upload_url
      Rails.logger.error "[GeminiService] Falha ao iniciar upload. Nenhuma URL retornada."
      return nil
    end

    file_uri = upload_file(upload_url)
    unless file_uri
      Rails.logger.error "[GeminiService] Falha ao fazer upload do arquivo. Nenhuma URI retornada."
      return nil
    end

    json_string = call_generate_content(file_uri)
    unless json_string
      Rails.logger.error "[GeminiService] Falha ao obter resposta do Gemini. Nenhum JSON retornado."
      return nil
    end

    parse_gemini_response(json_string)
  end

  private

  def parse_gemini_response(json_string)
    cleaned_string = json_string.strip.gsub(/^```json\n?/, "").gsub(/\n?```$/, "")

    data = JSON.parse(cleaned_string)

    {
      name: data["name"],
      price: data["price"].to_f,
      description: data["description"]
    }
  rescue JSON::ParserError => e
    Rails.logger.error "[GeminiService] Erro ao analisar JSON. Resposta bruta: #{json_string.inspect}. Erro: #{e.message}"
    nil
  end

  def start_resumable_upload
    file_size = File.size(@image_file.tempfile.path)

    url = "https://generativelanguage.googleapis.com/upload/v1beta/files?key=#{@api_key}"
    headers = {
      "X-Goog-Upload-Protocol" => "resumable",
      "X-Goog-Upload-Command" => "start",
      "X-Goog-Upload-Header-Content-Length" => file_size.to_s,
      "X-Goog-Upload-Header-Content-Type" => @image_file.content_type,
      "Content-Type" => "application/json"
    }
    body = {
      file: { display_name: @image_file.original_filename }
    }

    response = self.class.post(url, headers: headers, body: body.to_json)

    if response.success?
      response.headers["x-goog-upload-url"]
    else
      Rails.logger.error "[GeminiService] Erro ao iniciar upload resumível: #{response.body}"
      nil
    end
  end



  def upload_file(upload_url)
    file_content = @image_file.read

    headers = {
      "Content-Type" => @image_file.content_type,
      "X-Goog-Upload-Command" => "upload, finalize",
      "X-Goog-Upload-Offset" => "0"
    }

    response = self.class.post(upload_url, headers: headers, body: file_content)

    if response.success?
      response.parsed_response.dig("file", "uri")
    else
      Rails.logger.error "[GeminiService] Erro no upload da imagem: #{response.body}"
      nil
    end
  end



  def call_generate_content(file_uri)
    url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=#{@api_key}"
    headers = { "Content-Type" => "application/json" }
    body = {
      contents: [
        {
          parts: [
            { file_data: { mime_type: @image_file.content_type, file_uri: file_uri } },
            { text: @prompt }
          ]
        }
      ],
      generation_config: {
        response_mime_type: "application/json"
      }
    }

    response = self.class.post(url, headers: headers, body: body.to_json)

    if response.success?
      response.parsed_response.dig("candidates", 0, "content", "parts", 0, "text")
    else
      Rails.logger.error "[GeminiService] Erro ao gerar conteúdo com Gemini: #{response.body}"
      nil
    end
  end
end

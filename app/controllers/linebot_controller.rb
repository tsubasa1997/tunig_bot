class LinebotController < ApplicationController
    class LinebotController < ApplicationController
        require 'line/bot'  # gem 'line-bot-api'
    
        # callbackアクションのCSRFトークン認証を無効
        protect_from_forgery :except => [:callback]
      
        def client
          @client ||= Line::Bot::Client.new { |config|
            config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
            config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
          }
        end
      
        def callback
      
          # Postモデルの中身をランダムで@postに格納する
          @post=Post.offset( rand(Post.count) ).first
          body = request.body.read
      
          signature = request.env['HTTP_X_LINE_SIGNATURE']
          unless client.validate_signature(body, signature)
            head :bad_request
          end
      
          events = client.parse_events_from(body)
      
          events.each { |event|
      
            # event.message['text']でLINEで送られてきた文書を取得
            if event.message['text'].include?("レギュラー")
              response = "7弦：B 6弦：E 5弦:A 4弦:D 3弦：G　2弦:B 1弦:E"
            elsif event.message["text"].include?("c")
              response = "7弦：C 6弦：G 5弦:C 4弦:F 3弦：A　2弦:D 1弦:G"
            elsif event.message['text'].include?("a#")
              response = "7弦：A# 6弦：F 5弦:A# 4弦:D# 3弦：G　2弦:C 1弦:F"
            elsif event.message['text'].include?("a")
              response = "7弦：B 6弦：E 5弦:A 4弦:D 3弦：G　2弦:B 1弦:E"
            elsif event.message['text'].include?("g#")
                response = "7弦：G# 6弦：D# 5弦:G# 4弦:C# 3弦：F#　2弦:A# 1弦:D#"
            elsif event.message['text'].include?("g")
                response = "7弦：G 6弦：D 5弦:G 4弦:C 3弦：F 2弦:A 1弦:D"
            elsif event.message['text'].include?("f#")
                response = "7弦：F# 6弦：C# 5弦:F# 4弦:B 3弦：E 2弦:G# 1弦:C#"
            elsif event.message['text'].include?("f")
                response = "7弦：F 6弦：C 5弦:F 4弦:A# 3弦：D# 2弦:G 1弦:C"
            elsif event.message['text'].include?("e")
                response = "7弦：E 6弦：B 5弦:E 4弦:A 3弦：D 2弦:F# 1弦:B"
            else
              response = "そんなもんは無い"
            end
            #if文でresponseに送るメッセージを格納
      
            case event
            when Line::Bot::Event::Message
              case event.type
              when Line::Bot::Event::MessageType::Text
                message = {
                  type: 'text',
                  text: response
                }
                client.reply_message(event['replyToken'], message)
              end
            end
          }
      
          head :ok
        end
      end
    end
    
end

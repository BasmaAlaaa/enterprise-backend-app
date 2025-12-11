class OpenAiStreamChannel < ApplicationCable::Channel
  def subscribed
    stream_from "open_ai_stream_#{params[:generation_type]}_#{params[:integration_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
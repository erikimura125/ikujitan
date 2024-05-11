module RoomsHelper
  def most_new_message_preview(room)
    message = room.messages.order(updated_at: :desc).limit(1)
    message = message[0]
    if message.present?
      tag.p "#{message.message}", class: "dm_list__content__link__box__message"
    else
      tag.p "[ まだメッセージはありません ]", class: "dm_list__content__link__box__message"
    end
  end
  
  def opponent_user(room)
    entry = room.entries.where.not(user_id: current_user)
    nick_name = entry[0].user.nick_name
    tag.p "#{nick_name}", class: "dm_list__content__link__box__name"
  end
end
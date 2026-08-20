module ApplicationHelper
  def avatar_for(user, size: 36)
    if user.avatar.attached?
      cl_image_tag(user.avatar.key,
                   width: size * 2, height: size * 2, crop: :thumb, gravity: :face,
                   class: "avatar", alt: user.name)
    else
      tag.span(user.name.to_s.first.upcase,
               class: "avatar d-inline-flex align-items-center " \
                      "justify-content-center bg-info text-white fw-semibold")
    end
  end
end

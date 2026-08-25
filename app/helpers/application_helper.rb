module ApplicationHelper
  PET_FOCAL_POSITIONS = {
    "Biscuit" => "45% 28%",
    "Bin Chicken" => "50% 0%",
    "Crouton" => "50% 38%",
    "Kiwi" => "50% 38%",
    "Disco" => "50% 42%",
    "Prawn" => "50% 35%",
    "Professor Fluff" => "50% 42%",
    "Schnitzel" => "50% 45%"
  }.freeze

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

  def pet_photo_url(pet, size: 600)
    return cl_image_path(pet.avatar.key, width: size, height: size, crop: :fill, gravity: :auto) if pet.avatar.attached?

    pet.profile_pic.presence || "https://placehold.co/#{size}x#{size}?text=#{CGI.escape(pet.name)}"
  end

  def pet_focal_position(pet)
    PET_FOCAL_POSITIONS.fetch(pet.name, "50% 35%")
  end
end

module ApplicationHelper
  PET_FOCAL_POSITIONS = {
    "Biscuit" => "45% 28%",
    "Bin Chicken" => "50% 0%",
    "Crouton" => "50% 38%",
    "Kiwi" => "50% 38%",
    "Disco" => "50% 42%",
    "Prawn" => "50% 35%",
    "Professor Fluff" => "50% 42%",
    "Schnitzel" => "50% 45%",
    "Waffles" => "50% 72%"
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

  def pet_photo_url(pet, size: 600, height: size)
    if pet.avatar.attached?
      cl_image_path(pet.avatar.key, width: size, height: height, crop: :fill, gravity: :auto)
    else
      pet.profile_pic.presence ||
        "https://placehold.co/#{size}x#{height}?text=#{CGI.escape(pet.name)}"
    end
  end

  def trust_signal(viewer, other)
    return nil if viewer.nil? || other.nil? || viewer == other
    return { key: "connected", label: "You're connected" } if viewer.connected_with?(other)

    ids = viewer.mutual_neighbour_ids_with(other)
    return { key: "new", label: "New neighbour" } if ids.empty?

    { key: "mutual", label: mutual_sentence(ids) }
    if viewer.connected_with?(other)
      { key: "connected", label: "You're connected" } # rubocop:disable Lint/Void
    else
      mutuals = viewer.mutual_connections_with(other)
    end

    if mutuals.positive?
      { key: "mutual", label: pluralize(mutuals, "mutual connection") }
    else
      { key: "new", label: "New neighbour" }
    end
  end

  def pet_focal_position(pet)
    PET_FOCAL_POSITIONS.fetch(pet.name, "50% 35%")
  end

  def offer_status_badge(status)
    case status
    when "accepted" then ["Matched",      "matched"]
    when "rejected" then ["Not selected", "past"]
    else                 ["Pending",      "pending"]
    end
  end

  def distance_away(from, to)
    return nil unless from&.latitude && to&.latitude

    km = Geocoder::Calculations.distance_between(
      [from.latitude, from.longitude], [to.latitude, to.longitude], units: :km
    )
    km < 1 ? "#{(km * 1000).round(-1)}m away" : "#{km.round(1)}km away"
  end

  private

  def mutual_sentence(ids)
    if ids.size <= 3
      names = User.where(id: ids).order(:name).pluck(:name)
      "You both know #{names.to_sentence}"
    else
      names = User.where(id: ids).order(:name).limit(2).pluck(:name)
      "You both know #{names.to_sentence} and #{pluralize(ids.size - 2, 'other')}"
    end
  end
end

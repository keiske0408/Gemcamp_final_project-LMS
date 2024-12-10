class Client::InvitationsController < ApplicationController
  def show
    # Use promoter email from params, cookies, or fallback to the current signed-in user's email
    @promoter_email =  (current_client&.email.html_safe if client_signed_in?)

    # Save the promoter email in a cookie if it is present
    cookies[:promoter_email] = @promoter_email if @promoter_email

    # Generate the QR code with the full URL
    qrcode = RQRCode::QRCode.new(new_client_registration_url(promoter: @promoter_email))
    @qrcode_svg = qrcode.as_svg(offset: 0, color: '000', shape_rendering: 'crispEdges', module_size: 6)

    @invited_members = current_client.children
    @rewards = current_client.member_level

    @current_level = MemberLevel.where('required_members <= ?', @invited_members.count).order(:level).last
    @next_level = MemberLevel.where('required_members > ?', @invited_members.count).order(:required_members).first
  end
end

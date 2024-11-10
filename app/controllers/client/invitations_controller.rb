class Client::InvitationsController < ApplicationController
  def show
    @promoter_email = params[:promoter] || cookies[:promoter_email]

    if @promoter_email
      cookies[:promoter_email] = @promoter_email # Save promoter email in a cookie
    end

    qrcode = RQRCode::QRCode.new(new_client_registration_url(promoter: @promoter_email))
    @qrcode_svg = qrcode.as_svg(offset: 0, color: '000', shape_rendering: 'crispEdges', module_size: 6)
  end
end

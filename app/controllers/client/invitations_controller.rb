class Client::InvitationsController < ApplicationController
  skip_before_action :authenticate_client!, only: [:show]

  def show
    if params[:promoter]
      # Store the promoter in a cookie
      cookies[:promoter] = params[:promoter]
    end

    if current_client
      @invite_url = new_client_registration_url(promoter: current_client.email)
    else
      @invite_url = new_client_registration_url(promoter: "default@example.com")
    end

    # Generate QR code for the invite URL
    # Generate QR code for the invite URL
    qrcode = RQRCode::QRCode.new(@invite_url)

    # Generate PNG QR code as binary data
    png = qrcode.as_png(
      bit_depth: 1,
      color: 'black',
      bgcolor: 'white',
      module_px_size: 6,
      border_modules: 4
    )

    # Encode the PNG image to Base64 for inline display in HTML
    @qr_code = Base64.encode64(png.to_s)

  end
end


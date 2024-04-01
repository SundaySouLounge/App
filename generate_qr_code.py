# Import required libraries
import qrcode
from PIL import Image

# Define the data to be encoded in the QR code
data = "AdminAuthenticationKey"

# Generate QR code
qr = qrcode.QRCode(version=1, error_correction=qrcode.constants.ERROR_CORRECT_L, box_size=10, border=4)
qr.add_data(data)
qr.make(fit=True)

# Create an image from the QR code
img = qr.make_image(fill_color="black", back_color="white")

# Save the image to a file
img.save("admin_qr_code.png")

print("QR code generated successfully!")



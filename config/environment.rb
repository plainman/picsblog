# Load the Rails application.
require File.expand_path('../application', __FILE__)

IMAGE_DIR = '/uploads'
THUMBNAIL_DIR = IMAGE_DIR + '/thumbnails'

# Initialize the Rails application.
Picsblog::Application.initialize!

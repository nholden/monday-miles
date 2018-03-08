SecureHeaders::Configuration.default do |config|
  config.csp = {
    preserve_schemes: true,
    default_src: %w('self'),
    script_src: %w('self' 'unsafe-inline' 'unsafe-eval' www.googletagmanager.com www.google-analytics.com use.fontawesome.com www.youtube.com s.ytimg.com),
    style_src: %w('self' 'unsafe-inline' fonts.googleapis.com use.fontawesome.com www.w3.org),
    img_src: %w('self' *.cloudfront.net www.google-analytics.com maps.googleapis.com graph.facebook.com scontent.xx.fbcdn.net data:),
    font_src: %w('self' fonts.gstatic.com use.fontawesome.com),
    media_src: %w('self' www.youtube.com),
    child_src: %w('self' www.youtube.com),
    connect_src: %w('self' localhost:* ws://localhost:*),
  }
end

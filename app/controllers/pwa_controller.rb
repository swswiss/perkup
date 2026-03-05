class PwaController < ApplicationController
  protect_from_forgery except: :service_worker
  
  def manifest
    render template: "pwa/manifest", formats: :json
  end

  def service_worker
    render file: Rails.root.join("app/javascript/service-worker.js"),
           layout: false,
           content_type: "application/javascript"
  end
end

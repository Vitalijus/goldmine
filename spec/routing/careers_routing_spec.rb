require "rails_helper"

RSpec.describe CareersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/careers").to route_to("careers#index")
    end

    it "routes to #new" do
      expect(get: "/careers/new").to route_to("careers#new")
    end

    it "routes to #show" do
      expect(get: "/careers/1").to route_to("careers#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/careers/1/edit").to route_to("careers#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/careers").to route_to("careers#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/careers/1").to route_to("careers#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/careers/1").to route_to("careers#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/careers/1").to route_to("careers#destroy", id: "1")
    end
  end
end

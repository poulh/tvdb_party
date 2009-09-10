module TvdbParty
  class Search
    include HTTParty
    base_uri 'www.thetvdb.com/api'

    def initialize(the_api_key)
      @api_key = the_api_key
    end
    
    def search(series_name)
      response = self.class.get("/GetSeries.php", {:query => {:seriesname => series_name}})
      response["Data"]["Series"]
    end

    def get_series_by_id(series_id)
      response = self.class.get("/#{@api_key}/series/#{series_id}/en.xml")
      Series.new(self, response["Data"]["Series"])
    end
    
    def get_episode(series, season_number, episode_number)
      response = self.class.get("/#{@api_key}/series/#{series.id}/default/#{season_number}/#{episode_number}/en.xml")
      Episode.new(response["Data"]["Episode"])
    end

    def get_banners(series)
      response = self.class.get("/#{@api_key}/series/#{series.id}/banners.xml")
      case response["Banners"]["Banner"]
      when Array
        response["Banners"]["Banner"].map{|result| Banner.new(result)}
      when Hash
        Banner.new(response["Banners"]["Banner"])
      else
        []
      end
    end

  end
end
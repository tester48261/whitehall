module ServiceListeners
  class PanopticonRegistrar
    def initialize(edition)
      @edition = edition
    end

    def register!
      if can_register?
        nil
      end
    end

    def unregister!
      if can_register?
        nil
      end
    end

    private

    def url
      Whitehall.url_maker.document_path(@edition)
    end

    def can_register?
      @edition.is_a? DetailedGuide
    end
  end
end

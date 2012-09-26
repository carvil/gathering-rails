# -*- coding: UTF-8 -*-

module UseCases

  class Response < OpenStruct

    def ok?
      errors.nil? || errors.empty?
    end

  end

end

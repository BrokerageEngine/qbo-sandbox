require "qbo/sandbox/version"
require "qbo_api"

module Qbo
  class Sandbox
    attr_reader :from_connection, :to_connection

    def initialize(from_connection:, to_connection:)
        @from_connection = from_connection
        @to_connection = to_connection
        @from_connection.connect unless @from_connection.good?
        @to_connection.connect unless @to_connection.good?
    end


    def copy(entity, max: 1000, select: nil, inactive: false, batch_size: 30)
      batch = []
      QboApi.production = from_connection.production?
      from_connection.all(entity, max: max, select: select, inactive: inactive) do |e|
        batch << build_single_batch(e, entity)
      end
      submit_batch(batch, batch_size)
    end

    private

      def submit_batch(batch, batch_size)
        QboApi.production = false #Never copies to production
        collect_responses = []
        batch.each_slice(batch_size) do |b|
          payload = {"BatchItemRequest" => b}
          collect_responses << to_connection.batch(payload)
        end
        collect_responses
      end


      def build_single_batch(e, entity)
        {
          "bId" => "bid#{e.delete('Id')}",
          "operation" => "create",
          from_connection.singular(entity) => e
        }
      end

  end
end

require "qbo/sandbox/version"
require "qbo_api"

module Qbo
  class Sandbox
    attr_reader :prod, :sandbox

    def initialize(production_connection:, sandbox_connection:)
        @prod = production_connection
        @sandbox = sandbox_connection
        prod.connect unless prod.good?
        sandbox.connect unless sandbox.good?
    end


    def copy(entity, max: 1000, select: nil, inactive: false, batch_size: 30)
      batch = []
      QboApi.production = true
      prod.all(entity, max: max, select: select, inactive: inactive) do |e|
        batch << build_single_batch(e, entity)
      end
      submit_batch(batch, batch_size)
    end

    private

      def submit_batch(batch, batch_size)
        QboApi.production = false
        collect_responses = []
        batch.each_slice(batch_size) do |b|
          payload = {"BatchItemRequest" => b}
          collect_responses << sandbox.batch(payload)
        end
        collect_responses
      end


      def build_single_batch(e, entity)
        {
          "bId" => "bid#{e.delete('Id')}",
          "operation" => "create",
          prod.singular(entity) => e
        }
      end

  end
end

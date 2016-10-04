# The test requires RACK_ENV='test2'

require 'minitest/autorun'
require_relative '../../lib/mongo/document'

Mongo::Logger.logger.level = ::Logger::ERROR

Mongo::Document.client.database.drop

class Foo
  include Mongo::Document

  indexes.create_one(:bar => 1)
end

class MongoDocumentConfigTest < Minitest::Test
  def test_connection
    assert_instance_of Mongo::Client, Mongo::Document.connection
    assert_equal "mongo-document-test2", Foo.connection.database.name
  end
end


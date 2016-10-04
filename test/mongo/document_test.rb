require 'minitest/autorun'
require_relative '../../lib/mongo/document'

Mongo::Logger.logger.level = ::Logger::ERROR

Mongo::Document.establish_connection(
  :hosts => ["localhost:27017"],
  :database => "mongo-document-test",
)

Mongo::Document.client.database.drop

class SiteUser
  include Mongo::Document

  indexes.create_many([
    { :key => { :email => 1 }, :unique => true, :sparse => true },
    { :key => { :type => 1 }},
  ])
end

class Post
  include Mongo::Document

  self.collection_name = "awesome_posts"

  indexes.create_many([
    { :key => { :created_at => -1 }},
  ])
end

class MongoDocumentTest < Minitest::Test
  def test_descendants
    assert_equal [SiteUser, Post], Mongo::Document.descendants
  end

  def test_collection_name
    assert_equal "site_users", SiteUser.collection_name
    assert_equal "awesome_posts", Post.collection_name
  end

  def test_indexes
    # Indexes should have been created.
    names = SiteUser.indexes.map {|e| e['name'] }
    assert_equal %w(_id_ email_1 type_1), names

    names = Post.indexes.map {|e| e['name'] }
    assert_equal %w(_id_ created_at_-1), names

    # It should be OK to recreate the same index.
    SiteUser.indexes.create_one(:type => 1)
    names = SiteUser.indexes.map {|e| e['name'] }
    assert_equal %w(_id_ email_1 type_1), names
  end

  def test_connection
    assert_instance_of Mongo::Client, Mongo::Document.connection
    assert_instance_of Mongo::Client, SiteUser.connection
    assert_instance_of Mongo::Client, Post.connection
  end

  def test_collection
    assert_instance_of Mongo::Collection, SiteUser.collection
    assert_instance_of Mongo::Collection, Post.collection
  end

  def test_basic_read_and_write
    assert_equal 0, SiteUser.count
    SiteUser.insert_one(:email => 'a@b.com', :type => 'dev', :name => 'Bob')
    assert_equal 1, SiteUser.count
    users = SiteUser.find(:email => 'a@b.com').to_a
    assert_equal 1, users.size
    assert_equal 'Bob', users[0]['name']
  end

  def test_method_forwarding
    SiteUser.collection.public_methods.each do |name|
      assert_respond_to SiteUser, name
    end
  end

end


require 'test/unit'
require File.expand_path(File.join(File.dirname(__FILE__), '/testing_app/config/environment.rb'))

class QueryMemcachedTest < Test::Unit::TestCase
  
  def test_extract_table_names
    p  = "select * from pets"
    q = "select * from author_favorites where (author_favorites.author_id = 36) AND (author_favorites.user_id = 11) LIMIT 1"
    r = "SELECT * from binary_fields where (binary_fields.place_id = 3)"
    s = "select distinct(p.id) from pets p, binary_fields u, binary_fields pu, where pu.user_id = u.id and pu.place_id = p.id and p.id != 3"
    t = "select count(*) as count_all from pets inner join binary_fields on pets_id = binary_fields.place_id where (place_id = 3) AND (binary_fields.user_id = 11)"
    u = "select * from categories order by created_at DESC limit 10"
    v = "SELECT * from pets where id IN (SELECT * from pets where place_id = pets.id)"    
    w = "SELECT categories.* FROM categories INNER JOIN binary_fields ON binary_fields.id = categories.user_id WHERE ((binary_fields.contact_id = 1))"
    
    assert_equal ['pets'], ActiveRecord::Base.extract_table_names(p)
    assert_equal ['author_favorites'], ActiveRecord::Base.extract_table_names(q)
    assert_equal ['binary_fields'], ActiveRecord::Base.extract_table_names(r)
    assert_equal ['pets', 'binary_fields'], ActiveRecord::Base.extract_table_names(s)
    assert_equal ['pets', 'binary_fields'], ActiveRecord::Base.extract_table_names(t)
    assert_equal ['categories'], ActiveRecord::Base.extract_table_names(u)
    assert_equal ['pets'], ActiveRecord::Base.extract_table_names(v)
    assert_equal ['categories', 'binary_fields'], ActiveRecord::Base.extract_table_names(w)
  end
  
end

require 'test/unit'
require File.expand_path(File.join(File.dirname(__FILE__), '../../../../config/environment.rb'))

class Item < ActiveRecord::Base
end

class QueryMemcachedTest < Test::Unit::TestCase
  
  def test_extract_table_names
    private_methods = ActiveRecord::ConnectionAdapters::QueryCache.private_instance_methods    
    ActiveRecord::ConnectionAdapters::QueryCache.class_eval { public *private_methods }
    ActiveRecord::ConnectionAdapters::QueryCache.class_eval { module_function :extract_table_names }    
        
    p  = "select * from countries"
    q  = "SELECT_*_FROM_countries_"
    p2 = "select * from ratings where (ratings.item_id = 36) AND (ratings.user_id = 11) LIMIT 1"
    q2 = "SELECT_*_FROM_ratings_WHERE_(ratings.item_id_=_36)_AND_(ratings.user_id_=_11)_LIMIT_1" 
    p3 = "SELECT * from pictures where (pictures.place_id = 3)"
    q3 = "SELECT_*_FROM_pictures_WHERE_(pictures.place_id_=_3)_"
    p4 = "select distinct(p.id) from places p, users u, places_users pu, where pu.user_id = u.id and pu.place_id = p.id and p.id != 3"
    q4 = "0_select_distinct(p.id)_from_places_p,_users_u,_places_users_pu_where_pu.user_id_=_u.id_and_pu.place_id_=_p.id_and_p.id_!=_3"
    p5 = "select count(*) as count_all from places inner join places_users on places_id = places_users.place_id where (place_id = 3) AND (places_users.user_id = 11)"
    q5 = "0_SELECT_count(*)_AS_count_all_FROM_places_INNER_JOIN_places_users_ON_places.id_=_places_users.place_id_WHERE_(place_id_=_3)_AND_(places_users.user_id_=_11_)_"
    p6 = "select * from items order by created_at DESC limit 10"
    q6 = "SELECT_*_FROM_items_ORDER_BY_created_at_DESC_LIMIT_10"
    p7 = "SELECT * from countries where id IN (SELECT * from places where place_id = countries.id)"    
    q8 = "9_SELECT_users.*_FROM_users_INNER_JOIN_contacts_ON_users.id_=_contacts.user_id_WHERE_((contacts.contact_id_=_1))_"
    p8 = "SELECT users.* FROM users INNER JOIN contacts ON users.id = contacts.user_id WHERE ((contacts.contact_id = 1))"
    
    assert_equal ActiveRecord::ConnectionAdapters::QueryCache.extract_table_names(p).first,  ['countries']
    assert_equal ActiveRecord::ConnectionAdapters::QueryCache.extract_table_names(p2).first, ['ratings']
    assert_equal ActiveRecord::ConnectionAdapters::QueryCache.extract_table_names(p3).first, ['pictures']
    assert_equal ActiveRecord::ConnectionAdapters::QueryCache.extract_table_names(p4).first, ['places', 'users', 'places_users']
    assert_equal ActiveRecord::ConnectionAdapters::QueryCache.extract_table_names(p5).first, ['places', 'places_users']
    assert_equal ActiveRecord::ConnectionAdapters::QueryCache.extract_table_names(p6).first, ['items']
    assert_equal ActiveRecord::ConnectionAdapters::QueryCache.extract_table_names(p7).first, ['countries', 'places']
    assert_equal ActiveRecord::ConnectionAdapters::QueryCache.extract_table_names(p8).first, ['users', 'contacts']
  end
  
end

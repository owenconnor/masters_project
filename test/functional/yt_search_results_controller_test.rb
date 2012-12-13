require 'test_helper'

class YtSearchResultsControllerTest < ActionController::TestCase
  setup do
    @yt_search_result = yt_search_results(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:yt_search_results)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create yt_search_result" do
    assert_difference('YtSearchResult.count') do
      post :create, yt_search_result: { author_name: @yt_search_result.author_name, author_url: @yt_search_result.author_url, category: @yt_search_result.category, description: @yt_search_result.description, duration: @yt_search_result.duration, embed_url: @yt_search_result.embed_url, geo: @yt_search_result.geo, id: @yt_search_result.id, keywords: @yt_search_result.keywords, player_url: @yt_search_result.player_url, published: @yt_search_result.published, search_id: @yt_search_result.search_id, thumbnails: @yt_search_result.thumbnails, title: @yt_search_result.title, updated: @yt_search_result.updated, viewcount: @yt_search_result.viewcount }
    end

    assert_redirected_to yt_search_result_path(assigns(:yt_search_result))
  end

  test "should show yt_search_result" do
    get :show, id: @yt_search_result
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @yt_search_result
    assert_response :success
  end

  test "should update yt_search_result" do
    put :update, id: @yt_search_result, yt_search_result: { author_name: @yt_search_result.author_name, author_url: @yt_search_result.author_url, category: @yt_search_result.category, description: @yt_search_result.description, duration: @yt_search_result.duration, embed_url: @yt_search_result.embed_url, geo: @yt_search_result.geo, id: @yt_search_result.id, keywords: @yt_search_result.keywords, player_url: @yt_search_result.player_url, published: @yt_search_result.published, search_id: @yt_search_result.search_id, thumbnails: @yt_search_result.thumbnails, title: @yt_search_result.title, updated: @yt_search_result.updated, viewcount: @yt_search_result.viewcount }
    assert_redirected_to yt_search_result_path(assigns(:yt_search_result))
  end

  test "should destroy yt_search_result" do
    assert_difference('YtSearchResult.count', -1) do
      delete :destroy, id: @yt_search_result
    end

    assert_redirected_to yt_search_results_path
  end
end

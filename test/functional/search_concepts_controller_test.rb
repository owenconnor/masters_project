require 'test_helper'

class SearchConceptsControllerTest < ActionController::TestCase
  setup do
    @search_concept = search_concepts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:search_concepts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create search_concept" do
    assert_difference('SearchConcept.count') do
      post :create, search_concept: { is_node: @search_concept.is_node, name: @search_concept.name, terms: @search_concept.terms }
    end

    assert_redirected_to search_concept_path(assigns(:search_concept))
  end

  test "should show search_concept" do
    get :show, id: @search_concept
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @search_concept
    assert_response :success
  end

  test "should update search_concept" do
    put :update, id: @search_concept, search_concept: { is_node: @search_concept.is_node, name: @search_concept.name, terms: @search_concept.terms }
    assert_redirected_to search_concept_path(assigns(:search_concept))
  end

  test "should destroy search_concept" do
    assert_difference('SearchConcept.count', -1) do
      delete :destroy, id: @search_concept
    end

    assert_redirected_to search_concepts_path
  end
end

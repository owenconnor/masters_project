class SearchesController < ApplicationController
  before_filter :authenticate_user!
  EasyTranslate.api_key = 'AIzaSyCJ1HG7J7kKOJXaqaw2Cpgcc_W1kawYUbw'
  # GET /searches
  # GET /searches.json
  def index
    @searches = Search.all
    @personal_active_searches = Search.where(:user_id => current_user.id, :active_search => true)
    @personal_archive = Search.where(:user_id => current_user.id, :active_search => false)
    @newsroom_active_searches = Search.find(:all, :conditions => ["user_id NOT IN (?) AND active_search = ?", current_user.id, true])
    @newsroom_archive = Search.find(:all, :conditions => ["user_id NOT IN (?) AND active_search = ?", current_user.id, false])

    #Put the first thumbnail from the results as the search thumbnail
    @searches.each do |search|
      if YtSearchResult.where(:search_id => search.id).first != nil
        first_result = YtSearchResult.where(:search_id => search.id).first
        search.update_attributes(:thumbnail => first_result.thumbnails)
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @searches }
    end
  end

  # GET /searches/1
  # GET /searches/1.json
  def show
    @search = Search.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @search }
    end
  end

  # GET /searches/new
  # GET /searches/new.json
  def new
    @user = current_user.id
    # A search requires a Search ID, so make sure it is there
    if params.has_key?(:search_concept_id)
      @search = Search.new(:search_concept_id => params[:search_concept_id], :user_id => current_user.id)
    else
      @search = Search.new
    end

    if params[:pane] == "pane3"
      @search = Search.find(params[:search_id])
    end
    
    @search_concept_roots = SearchConcept.roots

    if params.has_key?(:get_children_of)
      @search_concept_items = SearchConcept.children_of(params[:get_children_of])
      @ancestors = SearchConcept.find(params[:get_children_of]).path
    else
       @search_concept_items = SearchConcept.roots
    end

    @search_concept_id = params[:search_concept_id]

    EasyTranslate.api_key = 'AIzaSyCJ1HG7J7kKOJXaqaw2Cpgcc_W1kawYUbw'
    @languages = Array.new
    @languages = ["Arabic", "French", "German", "Spanish", "Greek", "Swedish", "Dutch", "Japanese", "Chinese", "Indoneisan", "Italian", "Hebrew", "Portuguese"]
    logger.debug "@languages: #{@languages}"

    @possible_date_ranges = ["Today", "This Week", "This Month"]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @search }
    end
  end

  # GET /searches/1/edit
  def edit
    @search = Search.find(params[:id])
  end

  # POST /searches
  # POST /searches.json
  def create
    @search = Search.new(params[:search])

    respond_to do |format|
      if @search.save
        format.html { redirect_to new_search_path(:pane => 'pane3', :search_id => @search.id) }
        format.json { render json: @search, status: :created, location: @search }
      else
        format.html { render action: "new" }
        format.json { render json: @search.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /searches/1
  # PUT /searches/1.json
  def update
    @search = Search.find(params[:id])

    respond_to do |format|
      if @search.update_attributes(params[:search])
        format.html { redirect_to @search, notice: 'Search was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @search.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /searches/1
  # DELETE /searches/1.json
  def destroy
    @search = Search.find(params[:id])
    @search.destroy

    respond_to do |format|
      format.html { redirect_to searches_url }
      format.json { head :no_content }
    end
  end

  def stop_search
    search = Search.find(params[:id])
    search.update_attributes(:active_search => false )
    redirect_to searches_path
  end

  def start_search
    search = Search.find(params[:id])
    search.update_attributes(:active_search => true )
    redirect_to searches_path
  end
end

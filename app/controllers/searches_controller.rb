class SearchesController < ApplicationController
  EasyTranslate.api_key = 'AIzaSyCJ1HG7J7kKOJXaqaw2Cpgcc_W1kawYUbw'
  # GET /searches
  # GET /searches.json
  def index
    @searches = Search.all

    @searches.each do |search|
      first_result = YtSearchResult.where(:search_id => search.id).first
      search.update_attributes(:thumbnail => first_result.thumbnails)
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
    @search = Search.new#(:search_concept_id => params[:concept_id])
    if params[:list_parent_id].blank? == false
      @search_concept = SearchConcept.children_of(params[:list_parent_id])
    elsif params[:show_parent_id].blank? == false
      @search_concept = SearchConcept.find(params[:show_parent_id])
    else
      @search_concept = SearchConcept.roots
    end

    @search_concept_id = params[:search_concept_id]


    EasyTranslate.api_key = 'AIzaSyCJ1HG7J7kKOJXaqaw2Cpgcc_W1kawYUbw'
    @languages = Array.new
    @languages = EasyTranslate.translations_available
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
        format.html { redirect_to @search, notice: 'Search was successfully created.' }
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
end

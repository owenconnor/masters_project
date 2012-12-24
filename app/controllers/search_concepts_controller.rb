class SearchConceptsController < ApplicationController
  # GET /search_concepts
  # GET /search_concepts.json
  def index
    @search_concepts = SearchConcept.all
    

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @search_concepts }
    end
  end

  # GET /search_concepts/1
  # GET /search_concepts/1.json
  def show
    @search_concept = SearchConcept.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @search_concept }
    end
  end

  # GET /search_concepts/new
  # GET /search_concepts/new.json
  def new
    @search_concept = SearchConcept.new(:parent_id => params[:parent_id])

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @search_concept }
    end
  end

  # GET /search_concepts/1/edit
  def edit
    @search_concept = SearchConcept.find(params[:id])
  end

  # POST /search_concepts
  # POST /search_concepts.json
  def create
    @search_concept = SearchConcept.new(params[:search_concept])

    respond_to do |format|
      if @search_concept.save
        format.html { redirect_to @search_concept, notice: 'Search concept was successfully created.' }
        format.json { render json: @search_concept, status: :created, location: @search_concept }
      else
        format.html { render action: "new" }
        format.json { render json: @search_concept.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /search_concepts/1
  # PUT /search_concepts/1.json
  def update
    @search_concept = SearchConcept.find(params[:id])

    respond_to do |format|
      if @search_concept.update_attributes(params[:search_concept])
        format.html { redirect_to @search_concept, notice: 'Search concept was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @search_concept.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /search_concepts/1
  # DELETE /search_concepts/1.json
  def destroy
    @search_concept = SearchConcept.find(params[:id])
    @search_concept.destroy

    respond_to do |format|
      format.html { redirect_to search_concepts_url }
      format.json { head :no_content }
    end
  end
end

class ScenesController < ApplicationController
  before_filter :authenticate_user!, :confWidget

  def confWidget
    #TODO: Choose the widget that fits better in user's device screen
    @module = 'Desktop'
    @width = 600
    @height = 500
  end

  # GET /scenes
  # GET /scenes.json
  def index
    @scenes = Scene.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @scenes }
    end
  end

  # GET /scenes/1
  # GET /scenes/1.json
  def show
    @scene = Scene.find(params[:id])
    @mode = "view"

    respond_to do |format|
      format.html # show.html.erb
      format.js
      format.json { render json: @scene }
    end
  end

  # GET /scenes/new
  # GET /scenes/new.json
  def new
    @scene = Scene.new
    @mode = "edit"

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @scene }
    end
  end

  # GET /scenes/1/edit
  def edit
    @scene = Scene.find(params[:id])
    @mode = "edit"
  end

  # POST /scenes
  # POST /scenes.json
  def create
    @user = current_user
    @scene = @user.scenes.build(params[:scene])
    @mode = "edit"

    respond_to do |format|
      if @scene.save
        format.html { redirect_to @scene, notice: 'Scene was successfully created.' }
        format.json { render json: @scene, status: :created, location: @scene }
      else
        format.html { render action: "new" }
        format.json { render json: @scene.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /scenes/1
  # PUT /scenes/1.json
  def update
    @scene = Scene.find(params[:id])
    @mode = "edit"

    respond_to do |format|
      if @scene.update_attributes(params[:scene])
        format.html { redirect_to @scene, notice: 'Scene was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @scene.errors, status: :unprocessable_entity }
      end
    end
  end

  # Used to manage AJAX delete requests with JQuery dialog
  def delete
    @scene = Scene.find(params[:id])
    @err_msg = "You are not allowed to destroy this scene. Only the owner can delete it."
    @err_type = "Error delete"

    respond_to do |format|
      format.js # delete.js.erb
    end
  end

  def back_edit_ajax
    @scene = Scene.find(params[:id])
    @warn_msg = "Changes are not saved. If you leave they will be lost. Do really want to continue?"
    respond_to do |format|
      format.js # back_edit.js.erb
    end
  end

  # DELETE /scenes/1
  # DELETE /scenes/1.json
  def destroy
    @scene = Scene.find(params[:id])
    @user = current_user

    if @scene.user == @user
      @scene.destroy
      respond_to do |format|
        format.html { redirect_to scenes_url }
        format.js { render :nothing => true }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to scenes_url, notice: 'Not allowed.' }
        format.js { render :nothing => true, status: :unprocessable_entity }
        format.json { head :no_content }
      end
    end
  end
end

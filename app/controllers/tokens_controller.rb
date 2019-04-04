class TokensController < ApplicationController
  before_action :set_token, only: [:show, :edit, :update, :destroy]

  # GET /tokens
  # GET /tokens.json
  def index
    @search = params[:search] || ""
    @date = params[:date] || ""
    @pos = params[:pos] || ""

    begin
      date = Date.strptime(@date, "%Y-%m-%d")
    rescue
      date = Date.current
    end

    #@tokens = Token.all
    @poses = Token.select(:pos).order(:pos).map(&:pos).uniq
    @dates = Token.select(:created_at).order(:created_at).map(&:created_at).uniq.map{|x|x.strftime "%Y-%m-%d"}.uniq

    @tokens = Token.all.search(@search)
    @tokens = @tokens.where(created_at: date.midnight..date.end_of_day).distinct if !@date.empty? and @dates.include?(@date)
    @tokens = @tokens.where(pos: @pos).distinct if !@pos.empty? and @poses.include?(@pos)
    @tokens = @tokens.page(params[:page])
  end

  # GET /tokens/1
  # GET /tokens/1.json
  def show
  end

  # GET /tokens/new
  def new
    @token = Token.new
  end

  # GET /tokens/1/edit
  def edit
  end

  # POST /tokens
  # POST /tokens.json
  def create
    @token = Token.new(token_params)

    respond_to do |format|
      if @token.save
        format.html { redirect_to @token, notice: 'Token was successfully created.' }
        format.json { render :show, status: :created, location: @token }
      else
        format.html { render :new }
        format.json { render json: @token.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tokens/1
  # PATCH/PUT /tokens/1.json
  def update
    respond_to do |format|
      if @token.update(token_params)
        format.html { redirect_to @token, notice: 'Token was successfully updated.' }
        format.json { render :show, status: :ok, location: @token }
      else
        format.html { render :edit }
        format.json { render json: @token.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tokens/1
  # DELETE /tokens/1.json
  def destroy
    @token.destroy
    respond_to do |format|
      format.html { redirect_to tokens_url, notice: 'Token was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_token
      @token = Token.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def token_params
      params.require(:token).permit(:hiragana, :katakana, :kanji, :romaji, :german, :pos)
    end
end

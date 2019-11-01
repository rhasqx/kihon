class TokensController < ApplicationController
  before_action :set_common, only: [:index, :show, :edit, :update, :destroy]
  before_action :set_token, only: [:show, :edit, :update, :destroy]

  # GET /tokens
  # GET /tokens.json
  def index
    @tokens = Token.all.search(@search)
    @tokens = @tokens.where(course: @course) if !@course.empty? and @courses.include?(@course)
    @tokens = @tokens.where(number: @number) if !@number.empty? and @numbers.include?(@number)
    @tokens = @tokens.where(pos: @pos) if !@pos.empty? and @poses.include?(@pos)
    @tokens = @tokens.joins(:token_order).order('tokens.course, tokens.number, token_orders.weight, tokens.created_at')

    respond_to do |format|
      format.html do
        @size = @tokens.size
        @tokens = @tokens.page(params[:page]).per(@perpage)
      end
      format.pdf do
        send_data CardsPdf.new(@tokens).render,
          filename: "cards.pdf",
          type: "application/pdf",
          disposition: 'inline'
      end
    end
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
    def set_common
      @courses = Naturally.sort Token.all.map(&:course).sort.uniq
      @numbers = Naturally.sort Token.all.map(&:number).sort.uniq
      @poses = Naturally.sort TokenOrder.all.map(&:name).sort.uniq # Token.all.map(&:pos).sort.uniq

      @search = params[:search] || ""
      @perpage = params[:perpage].to_i
      @perpage = Kaminari.config.default_per_page if @perpage < 1
      @perpage = [@perpage, 500].min
      @course = params[:course] || ""
      @number = params[:number] || ""
      @pos = params[:pos] || ""

      @params = {
        :search => @search,
        :perpage => @perpage,
        :course => @course,
        :number => @number,
        :pos => @pos
      }
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def token_params
      params.require(:token).permit(:hiragana, :katakana, :kanji, :german, :english, :pos)
    end
end

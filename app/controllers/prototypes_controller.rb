class PrototypesController < ApplicationController
 before_action :authenticate_user!, only: [:new, :edit, :destroy ]
 before_action :move_to_index,  except: [:index, :show, :new]

    def new
      @prototype =Prototype.new
    end

    def create
      Prototype.create(prototype_params)
      if Prototype.create
        redirect_to root_path
      else
        render :new
      end
    end

    def index
      @prototypes = Prototype.all
    end

    def show
      
      @prototype =Prototype.find(params[:id])
      @comment = Comment.new
      @comments = @prototype.comments.includes(:user)
    end

    def edit
      @prototype = Prototype.find(params[:id])
      
    end

    def update
      prototype = Prototype.find(params[:id])
      if prototype.update(prototype_params)
        redirect_to  prototype_path
      else
        @prototype = Prototype.find(params[:id])
        render :edit
      end
    end

    def destroy
      prototype = Prototype.find(params[:id])
      prototype.destroy
      redirect_to root_path
    end


private
    def prototype_params
      params.require(:prototype).permit(:title, :catch_copy,:concept,:image,).merge(user_id: current_user.id)
    end

    def move_to_index
      @prototype = Prototype.find(params[:id])
      unless  @prototype.user_id == current_user.id
        redirect_to action: :index

      end
    end
end
# エラー文に"Couldn't find User with 'id'=4"と書いてあります。意味としては、「id=4のユーザーはないよ」と言っています
# 。なぜ、このようなことになっているかというと、
# novel_listsコントローラで@user = User.find(params[:id])としているからです。
# 今、id=4のノベルをクリックしているのでparams[:id]の値は4となります。なので、id=4のユーザーを探しに行った結果、
# id=4のユーザーは存在しないよと言っています。

# そもそも、novel_listの中にユーザーidの情報が入っているので、そこでわざわざ@userとしなくていいと思います。
# Novel_listテーブルとUserテーブルをアソシエーションで結んでいれば、例えば、ビュー側で@novel_list.user.nameとすれば、
# ユーザーの情報は表示できると思います。
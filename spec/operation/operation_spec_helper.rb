shared_examples "object" do 
  | update |
  it 'can get info' do
    result = subject.info
    is_success( result )
  end

  it 'can update it self' do
    result = subject.update(  update )
    is_success( result )
  end
end

# 在这之前要describ object
shared_examples "object operator" do 
  |object_name,  add_info, update_info |
  object_id = 0
  
  it 'can add object' do
    method_name = "add_"+object_name
    result = subject.send( method_name.to_sym, add_info )
    is_success( result )
    object_id = result[:result][0][:id]
  end

  it 'can update object' do
    method_name = "update_"+object_name
    result = subject.send( method_name.to_sym, update_info.merge( {id:object_id} ) )
    is_success( result )
  end

  it 'can delete object' do
    method_name = "delete_"+object_name
    result = subject.send( method_name.to_sym, object_id )
    is_success( result )
  end
end

  shared_examples "object parent" do
    | object_name| 
    it 'can get all objects'do
      result = subject.send( (object_name + 's').to_sym ) 
      is_success( result )
    end 

    it 'can get all object ids' do
      result = subject.send( (object_name + '_ids').to_sym ) 
      is_success( result )
    end
end


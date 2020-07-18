pico-8 cartridge // http://www.pico-8.com
version 27
__lua__
--2d platform physics engine
--by alex mcculloch

--start
function _init()
    create_player_variables()
    create_shapes()
    create_rigidbodys()
    create_scene()
    create_game_objects()
    create_main_character()
end

function create_player_variables()
    player_force_x = 0
    player_force_y = 0
end

function create_shapes()
    
    s_rect_shapes = {}
    --create_rectangles(rects,amount,width,height,flip_x,flip_y)
    create_rectangles(s_rect_shapes,12,7,7,false,false)
    --create_fixed_rect(width,height,flip_x,flip_y)
    c_rect_shapes = {}
    create_rectangles(c_rect_shapes,1,7,7,false,false)
end

function create_rigidbodys()
    --create_rigidbody(shape,x,y,bounce,friction,mass)
    s_rigid_bodies = {}
    
    s_rigid_bodies[1] = create_rigidbody(s_rect_shapes[1],0,80,0,0,0,"climb")
    s_rigid_bodies[2] = create_rigidbody(s_rect_shapes[2],8,80,0,0,0,"climb")
    s_rigid_bodies[3] = create_rigidbody(s_rect_shapes[3],16,72,0,0,0,"climb")
    s_rigid_bodies[4] = create_rigidbody(s_rect_shapes[4],24,64,0,0,0,"climb")
    s_rigid_bodies[5] = create_rigidbody(s_rect_shapes[5],32,56,0,0,0,"no_climb")
    s_rigid_bodies[6] = create_rigidbody(s_rect_shapes[6],32,48,0,0,0,"no_climb")
    s_rigid_bodies[7] = create_rigidbody(s_rect_shapes[7],40,48,0,0,0,"climb")
    s_rigid_bodies[8] = create_rigidbody(s_rect_shapes[8],48,48,0,0,0,"climb")
    s_rigid_bodies[9] = create_rigidbody(s_rect_shapes[9],56,48,0,0,0,"climb")
    s_rigid_bodies[10] = create_rigidbody(s_rect_shapes[10],64,40,0,0,0,"climb")
    s_rigid_bodies[11] = create_rigidbody(s_rect_shapes[11],72,16,0,0,0,"climb")
    s_rigid_bodies[12] = create_rigidbody(s_rect_shapes[12],80,16,0,0,0,"climb")

    --create_rigidbody(shape,x,y,bounce,friction,mass)
    c_rigid_bodies = {}
    c_rigid_bodies[1] = create_rigidbody(c_rect_shapes[1],5,0,1.9,0.9,1)
end

function create_scene()
    solid_obj_index = 0
    solid_scene_objects = {}
    scene_pillar_objects = {}
    scene_objects = {}
    scene_stair_objects = {}
    scene_ground_objects = {}

    --[[
    --create_scene_object(rigid_body,spr_id)
    create_scene_square_objects(scene_objects,s_rigid_bodies,12,2)
    register_scene_coll_objects(solid_scene_objects,scene_objects)
    ]]
    --create_solid_pillar(pillar_objects,height,spr_id,ix,iy)
    create_solid_pillar(scene_pillar_objects,3,1,0,48)
    register_scene_coll_objects(solid_scene_objects,scene_pillar_objects)
    --create_ground(ground_objects,width,spr_id,ix,iy)
    create_ground(scene_ground_objects,5,1,2*8,90)
    register_scene_coll_objects(solid_scene_objects,scene_ground_objects)
    --create_stairs(stair_objects,height_displacement, spr_id,ix,iy)
    create_stairs(scene_stair_objects,-5,1,7*8,90)
    register_scene_coll_objects(solid_scene_objects,scene_stair_objects)
end

function create_game_objects()
    --create_game_object(rigid_body,sprite_id,player?)
    game_objects = {}
    game_objects[1] = create_game_object(c_rigid_bodies[1],1,true)
end

function create_main_character()
  set_force(game_objects[1],0,0)
end

-->8
--update
function _update()
    update_inputs()
    update_physics()
    update_camera()
    update_game_logic()
end

--handles player input
function update_inputs()
    input()
end

function update_physics()
    local p = game_objects[1].rigid_body
    apply_force(game_objects[1],player_force_x,player_force_y,0.4)

end

function update_game_logic()

end

function update_camera()

end
-->8
--drawing
function _draw()
    cls()
    draw_background()
    draw_scene_objects()
    --draw_game_objects()
    draw_main_character()
    draw_GUI()
end

function draw_background()
    
end

function draw_scene_objects()
    local objects = nil
    for i=1, #solid_scene_objects do
        objects = solid_scene_objects[i]
        for j=1, #objects do
            objects[j]:draw()
        end
        
    end
   
end

function draw_game_objects()
    
    for i=1, #game_objects do
        game_objects[i]:draw()      
    end
end

function draw_main_character()
    local r = game_objects[1].rigid_body
    
    rect(r.pos.x,r.pos.y,r.pos.x+r.shape.width, r.pos.y+r.shape.height)
end

function draw_GUI()
    print(game_objects[1].rigid_body.pos.y)

end
-->8
--scene
function create_scene_object(rb,spr_num)
    local scene_object =
    {
        rigid_body = rb,
        sprite_num = spr_num,
        type = "static",
        draw = function(self)
            if self.rigid_body.shape.type == "rect" then
                local id = self.sprite_num
                local x = self.rigid_body.pos.x
                local y = self.rigid_body.pos.y
                local w = self.rigid_body.shape.width
                local h = self.rigid_body.shape.height
                local fx = self.rigid_body.shape.flip_x
                local fy = self.rigid_body.shape.flip_y
                spr(id,round(x),round(y),w/7,h/7,fx,fy)
            end
        end
    }
    return scene_object
end

function create_ground(ground_objects,width,spr_id,ix,iy)
    local ground_shapes = {}
    local ground_rigid_bodies = {}
     --create_rectangles(rects,amount,width,height,flip_x,flip_y)
     create_rectangles(ground_shapes,width,7,7,false,false)
     ground_rigid_bodies[1] = create_rigidbody(ground_shapes[1],ix,iy,0,0,1,"climb")
     for i=2, width do
        ground_rigid_bodies[i] = create_rigidbody(ground_shapes[i],ix+i*8-8,iy,0,0,1,"climb")
    end
    create_scene_square_objects(ground_objects,ground_rigid_bodies,width,spr_id)
end

function create_stairs(stair_objects,height_displacement, spr_id,ix,iy)
    local stair_shapes = {}
    local stair_rigid_bodies = {}
    local direction = height_displacement/abs(height_displacement)
     --create_rectangles(rects,amount,width,height,flip_x,flip_y)
     create_rectangles(stair_shapes,abs(height_displacement),7,7,false,false)
     stair_rigid_bodies[1] = create_rigidbody(stair_shapes[1],ix,iy,0,0,1,"climb")

    if direction > 0 then
        for i=2, abs(height_displacement) do
            stair_rigid_bodies[i] = create_rigidbody(stair_shapes[i],ix+i*8-8,iy+i*8-8,0,0,1,"climb")
        end
    else
        for i=2, abs(height_displacement) do
            stair_rigid_bodies[i] = create_rigidbody(stair_shapes[i],ix+i*8-8,iy-(i*8-8),0,0,1,"climb")
        end
    end

    create_scene_square_objects(stair_objects,stair_rigid_bodies,abs(height_displacement),spr_id)
end

function create_solid_pillar(pillar_objects,height,spr_id,ix,iy)
    local pillar_shapes = {}
    local pillar_rigid_bodies = {}
     --create_rectangles(rects,amount,width,height,flip_x,flip_y)
    create_rectangles(pillar_shapes,height,7,7,false,false)
    pillar_rigid_bodies[1] = create_rigidbody(pillar_shapes[1],ix,iy,0,0,1,"no_climb")
    for i=2, height do
        pillar_rigid_bodies[i] = create_rigidbody(pillar_shapes[i],ix,iy+i*8-8,0,0,1,"no_climb")
    end
    create_scene_square_objects(pillar_objects, pillar_rigid_bodies,height,spr_id)
end

function create_scene_square_objects(objects,rigid_bodies,amount,spr_id)
    for i=1, amount do
        objects[i] = create_scene_object(rigid_bodies[i],spr_id)
    end
end



-->8
--game_objects
function create_game_object(rb,spr_num,p)
    local game_object =
    {
        static_x = 0,
        static_y = 0,
        player = p,
        rigid_body = rb,
        sprite_num = spr_num,
        type = "dynamic",
        draw = function(self)
            if self.rigid_body.shape.type == "rect" then
                local id = self.sprite_num
                local x = self.rigid_body.pos.x
                local y = self.rigid_body.pos.y
                local w = self.rigid_body.shape.width
                local h = self.rigid_body.shape.height
                local fx = self.rigid_body.shape.flip_x
                local fy = self.rigid_body.shape.flip_y

                spr(id,x,y,w/7,h/7,fx,fy)
            end
        end
    }
    return game_object
end

function create_rectangles(rects,amount,width,height,flip_x,flip_y)
    --create_fixed_rect(width,height,flip_x,flip_y)
    for i=1, amount do
        rects[i] = create_fixed_rect(width,height,flip_x,flip_y)
    end
end

function create_rigidbody(body,ix,iy,b,f,m,fs)
    local rigid_body =
    {
        shape = body,
        pos = 
        {
            x = ix,
            y = iy
        },
        bounce = b,
        friction = 0.87,
        inertia = 0.8,
        free_sides = fs,
        on_ground = false,
        falling = false,
        mass = m,
        accel = 
        {
            x = 0,
            y = 0
        },
        vel = 
        {
            x = 0,
            y = 0
        },
        force =
        {
            x = 0,
            y = 0   
        }
    } 
    return rigid_body
end

function create_fixed_rect(w,h,fx,fy)
    local rect = 
    {
        type = "rect",
        width = w,
        height = h,
        flip_x = fx,
        flip_y = fy
    }

    return rect
end

-->8
--physics
function set_mass(game_object,mass)
    game_object.rigid_body.mass = mass
end

function set_force(game_object,force_x,force_y)
    game_object.rigid_body.force.x =  force_x
    game_object.rigid_body.force.y =  force_y
end

function add_force(game_object,force_x,force_y)
    local r = game_object.rigid_body
    game_object.rigid_body.force.x = r.force.x + force_x
    game_object.rigid_body.force.y = r.force.y + force_y
end

function update_gravity(game_object,gravity)
    local r = game_object.rigid_body

    add_force(game_object,r.force.x, gravity * r.mass) 
end

function update_acceleration(game_object)
    local r = game_object.rigid_body
    game_object.rigid_body.accel.x = r.force.x / r.mass
    game_object.rigid_body.accel.y = r.force.y / r.mass
end

function update_velocity(game_object)
    local r = game_object.rigid_body
    game_object.rigid_body.vel.x = r.vel.x + r.accel.x
    game_object.rigid_body.vel.y = r.vel.y + r.accel.y

    
end

function update_position(game_object)
    local r = game_object.rigid_body
    game_object.rigid_body.pos.x = r.pos.x + r.vel.x

    game_object.rigid_body.pos.y = r.pos.y + r.vel.y
end

function update_slowdown(game_object)
    local r = game_object.rigid_body
    
    game_object.rigid_body.force.x = r.force.x * r.inertia
    game_object.rigid_body.force.y = r.force.y * r.inertia
    game_object.rigid_body.vel.x = r.vel.x * r.friction
    game_object.rigid_body.vel.y = r.vel.y * r.friction
    
end

function zero_out(game_object)
    game_object.rigid_body.force.x = 0
    game_object.rigid_body.force.y = 0
end

function update_uncollide(game_object,ss_index,s_index,side)
    
    zero_out(game_object)

    local sx = solid_scene_objects[ss_index][s_index].rigid_body.pos.x + 4
    local sy = solid_scene_objects[ss_index][s_index].rigid_body.pos.y + 4
    local gx = game_object.rigid_body.pos.x + 4
    local gy = game_object.rigid_body.pos.y + 4
    local x = gx - sx
    local y = gy - sy
   

    local angle = atan2(x,y)

    while rect_collide(game_object,solid_scene_objects[ss_index][s_index]) do
        
        
        if solid_scene_objects[ss_index][s_index].rigid_body.free_sides == "climb" then
            if gy < sy then
                game_object.rigid_body.pos.y = game_object.rigid_body.pos.y + sin(angle)
            elseif gy > sy then
                game_object.rigid_body.pos.y = game_object.rigid_body.pos.y - sin(angle)
            end
        end
        if solid_scene_objects[ss_index][s_index].rigid_body.free_sides == "no_climb" then
            if gy < sy then
                game_object.rigid_body.pos.y = game_object.rigid_body.pos.y + sin(angle)
            end

            if gx < sx and gy+2 > sy then
                game_object.rigid_body.pos.x = game_object.rigid_body.pos.x - 1
            elseif gx > sx and gy+2 > sy then
                game_object.rigid_body.pos.x = game_object.rigid_body.pos.x + 1
            end
        end
    end        
end

function apply_force(game_object,force_x,force_y,grav)
    set_force(game_object,force_x,force_y+grav)
    update_acceleration(game_object)
    update_velocity(game_object)
    update_slowdown(game_object)
    update_position(game_object)
    for i=1, #solid_scene_objects do
        check_collisions_with_scene(game_object,force_x,force_y,i) 
    end
end

function check_collisions_with_scene(game_object,force_x,force_y,ss_index)
    local side = "none"
    local collided = false
    local objects = solid_scene_objects[ss_index]
    for i=1, #objects do
        collided, side = rect_collide(game_object,objects[i])
        if collided then
            index = i    
            update_uncollide(game_object,ss_index,i,side)  
            if side == "bottom" then game_object.rigid_body.on_ground = true end
        end
    end
end

function register_scene_coll_objects(to, object)
    solid_obj_index = solid_obj_index + 1
    to[solid_obj_index] = object
end

function flush_scene_coll_objects(to)
    for i=1, solid_obj_index do
        to[i] = nil
    end

    solid_obj_index = 0
end

function overlapping(mina,maxa,minb,maxb)
    return minb<=maxa and mina<=maxb 
end

function rect_collide(a,b)
    local recta = a.rigid_body
    local rectb = b.rigid_body
    local aleft = recta.pos.x
    local aright = aleft + recta.shape.width 
    local bleft = rectb.pos.x
    local bright = bleft + rectb.shape.width 
    local abottom = recta.pos.y 
    local atop = abottom + recta.shape.height 
    local bbottom = rectb.pos.y 
    local btop = bbottom + rectb.shape.height 
    
    if overlapping(aleft,aright,bleft,bright) and overlapping(abottom,atop,bbottom,btop) then
      return true
    else
        return false
    end
end

-->8
--player controller
function input()
    if btn(0) and player_force_x > -0.5 then
        player_force_x = player_force_x - 0.3
    elseif btn(1) and player_force_x < 0.5 then
        player_force_x = player_force_x + 0.3
    else
        player_force_x = 0
    end

    if btnp(2) and player_force_y > -0.3 then
        player_force_y = player_force_y - 12
    else
        player_force_y = 0
    end
end

-->8
--helper functions
function round(num)
 if (num - flr(num)) * 10 >= 5 then
 	return ceil(num)
 else
 	return flr(num)
 end
end

__gfx__
00000000b33333bbbbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bb33bbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007004bbbbb44bbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700044bb4442bbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0007700044444424bbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070024444444bbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000042444444bbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000044444444bbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000


[Tri,Pts]=obj_read('test1.obj');
[Tri2,Beq]=obj_read('test2.obj');
Aeq=[1;5;23;54;112;167;268;368;279;489;478];
Beq=Beq(Aeq,:);
Beq=Beq+rand(size(Beq))/100;

obj_write('recover.obj',Tri,t)
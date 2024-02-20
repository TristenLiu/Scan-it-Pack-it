from py3dbp import Packer, Bin, Item, Painter
import time
start = time.time()

'''

This case is used to demonstrate the scenario where all objects fit perfectly in the container.

'''

# init packing function
packer = Packer()
#  init bin
box = Bin('test1',(53.3, 40.6, 40.4), 100, 0, 0)
packer.addBin(box)
# add item
packer.addItem(Item(partno='1',name='test',typeof='cube', WHD=(30, 40, 10), weight=1, level=1,loadbear=100, updown=True, color='pink'))
packer.addItem(Item(partno='2',name='test',typeof='cube', WHD=(15, 39, 22), weight=1,level= 1,loadbear=100, updown=True, color='brown'))
packer.addItem(Item(partno='3',name='test',typeof='cube', WHD=(24, 5, 9), weight=1,level= 1,loadbear=100, updown=True, color='cyan'))
packer.addItem(Item(partno='4',name='test',typeof='cube', WHD=(35, 8, 12), weight=1,level= 1,loadbear=100, updown=True, color='purple'))
packer.addItem(Item(partno='5',name='test',typeof='cube', WHD=(53.3, 40.6, 10), weight=1, level=1,loadbear=100, updown=True, color='yellow'))
packer.addItem(Item(partno='6',name='test',typeof='cube', WHD=(39, 32, 10), weight=1,level= 1,loadbear=100, updown=True, color='purple'))


# calculate packing 
packer.pack(
    bigger_first=True,
    distribute_items=False,
    fix_point=True,
    check_stable=True,
    support_surface_ratio=0.75,
    number_of_decimals=0
)

# print result
b = packer.bins[0]
volume = b.width * b.height * b.depth
print(":::::::::::", b.string())

print("FITTED ITEMS:")
volume_t = 0
volume_f = 0
unfitted_name = ''
for item in b.items:
    print("partno : ",item.partno)
    print("color : ",item.color)
    print("position : ",item.position)
    print("rotation type : ",item.rotation_type)
    print("W*H*D : ",str(item.width) +'*'+ str(item.height) +'*'+ str(item.depth))
    print("volume : ",float(item.width) * float(item.height) * float(item.depth))
    print("weight : ",float(item.weight))
    volume_t += float(item.width) * float(item.height) * float(item.depth)
    print("***************************************************")
print("***************************************************")
print("UNFITTED ITEMS:")
for item in b.unfitted_items:
    print("partno : ",item.partno)
    print("color : ",item.color)
    print("W*H*D : ",str(item.width) +'*'+ str(item.height) +'*'+ str(item.depth))
    print("volume : ",float(item.width) * float(item.height) * float(item.depth))
    print("weight : ",float(item.weight))
    volume_f += float(item.width) * float(item.height) * float(item.depth)
    unfitted_name += '{},'.format(item.partno)
    print("***************************************************")
print("***************************************************")
print('space utilization : {}%'.format(round(volume_t / float(volume) * 100 ,2)))
print('residual volumn : ', float(volume) - volume_t )
print('unpack item : ',unfitted_name)
print('unpack item volumn : ',volume_f)
#print("gravity distribution : ",b.gravity)
stop = time.time()
print('used time : ',stop - start)

# draw results
painter = Painter(b)
fig = painter.plotBoxAndItems(
    title=b.partno,
    alpha=0.2,
    write_num=True,
    fontsize=10
)
fig.show()
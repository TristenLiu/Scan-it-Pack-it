from py3dbp import Packer, Bin, Item, Painter

def pack(width, height, depth):
    packer = Packer()

    container = Bin(
        partno="container",
        WHD=(width[0],height[0],depth[0]),
        max_weight=20,
        corner=0,
        put_type=0
    )
    packer.addBin(container)

    for enum, item in enumerate(zip(width[1:], height[1:], depth[1:])):
        packer.addItem(Item(
            partno=f"{enum}",
            name="box",
            typeof="cube",
            WHD=item,
            weight=1,
            level=1,
            loadbear=100,
            updown=True,
            color="brown"
        ))

    packer.pack(
        bigger_first=True,                 # bigger item first.
        fix_point=True,                    # fix item float problem.
        distribute_items=False,            # If multiple bin, to distribute or not.
        check_stable=True,                 # check stability on item.
        support_surface_ratio=0.75,        # set support surface ratio.
        number_of_decimals=0
    )

    print(packer.bins)
    print(packer.bins[0].items)
    print(packer.unfit_items)
   
def check_input(values):
    vals = values.split()
    if len(vals) != 3:
        print("Error! Please enter three dimensions")
        return 0
    elif vals[0].isalpha() or vals[1].isalpha() or vals[2].isalpha():
        print("Error! All dimensions must be numerical")
        return 0
    w, h, d = [float(val) for val in vals]
    if w <= 0 or h <= 0 or d <= 0:
        print("Error! All dimensions must be non-zero and positive!")
        return 0
    
    return (w, h, d) 
    
if __name__=="__main__":
    inputting = True
    width = []
    height = []
    depth = []

    print("###########################################################################")
    print("Enter the all dimensions in the format: 'Width Height Depth'")
    print("All dimensions must be numerical, non-zero and positive")
    print("When all the dimensions are inputted, enter: 'fin'")
    print("###########################################################################")

    values = input("Enter the dimensions of the container: ")
    
    ret = check_input(values)
    if ret == 0:
        exit()
    else:
        width.append(ret[0])
        height.append(ret[1])
        depth.append(ret[2])
    

    while(inputting):
        dim = input("Enter the dimensions of a box: ")
        if (dim == "fin"):
            break
        
        ret = check_input(dim)
        if ret == 0:
            exit()
        else:
            width.append(ret[0])
            height.append(ret[1])
            depth.append(ret[2])

    # print(f"{width}, {height}, {depth}")
    pack(width, height, depth)


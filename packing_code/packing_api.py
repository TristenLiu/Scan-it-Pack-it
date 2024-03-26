from flask import Flask, request, jsonify
from py3dbp import Packer, Bin, Item
import time
import random

app = Flask(__name__)

@app.route('/', methods=['POST'])

def packing_algorithm():
    start = time.time()

    data = request.get_json()

    packer = Packer()
    box_dimensions = data['bin_dimensions']
    box = Bin('test1', (box_dimensions['width'], box_dimensions['height'], box_dimensions['depth']), 100 , 0 ,0)
    packer.addBin(box)

    for item_data in data['items']:
        item = Item(partno=item_data['partno'],
                    name=item_data['name'],
                    typeof=item_data['typeof'],
                    WHD=(item_data['width'], item_data['height'], item_data['depth']),
                    weight=item_data['weight'],
                    level=item_data['level'],
                    loadbear=item_data['loadbear'],
                    updown=item_data['updown'],
                    color=randColor(22))
        packer.addItem(item)

    packer.pack(
        bigger_first=True,
        distribute_items=False,
        fix_point=True,
        check_stable=True,
        support_surface_ratio=0.75,
        number_of_decimals=0
    )

    b = packer.bins[0]
    volume = b.width * b.height * b.depth
    volume_t = 0
    volume_f = 0
    unfitted_name = ''
    stop = time.time()

    result = {
        "bin": b.string(),
        "fitted_items": [],
        "unfitted_items": [],
        "used_time": stop - start
    }


    # Fitted items
    for item in b.items:
        volume_item = float(item.width) * float(item.height) * float(item.depth)
        volume_t += volume_item
        result["fitted_items"].append({
            "partno": item.partno,
            "position": item.position,
            "rotation_type": item.rotation_type,
            "dimensions": (item.width, item.height, item.depth),
            "volume": item.width * item.height * item.depth,
            "weight": item.weight
        })

    # Unfitted items
    for item in b.unfitted_items:
        volume_item = float(item.width) * float(item.height) * float(item.depth)
        volume_f += volume_item
        result["unfitted_items"].append({
            "partno": item.partno,
            "dimensions": (item.width, item.height, item.depth),
            "volume": item.width * item.height * item.depth,
            "weight": item.weight,
        })
    
    result["space_utilization"] = "{:.2f}".format(round(volume_t / float(volume) * 100, 2))
    result["residual_volume"] = float(volume) - volume_t
    result["unpack_item_volume"] = volume_f

    return jsonify(result)

def randColor(s):
    random.seed(s)
    color = "#"+''.join([random.choice('0123456789ABCDEF') for j in range(6)])


if __name__ == '__main__':
    # app.run(debug=True)
    app.run(host='0.0.0.0', port=5000)

import open3d as o3d
import numpy as np

# Load the .xyz file
pcd = o3d.io.read_point_cloud("./test_files/5_boxes.xyz")

# Visualize the original point cloud
print("Visualizing the original point cloud:")
# o3d.visualization.draw_geometries([pcd], point_show_normal=False)

# Estimate normals for the point cloud
pcd.estimate_normals(search_param=o3d.geometry.KDTreeSearchParamHybrid(radius=0.1, max_nn=30))

# Perform plane segmentation to remove the floor
# We will start with a small threshold and increase it if necessary
distance_thresholds = [0.02, 0.05, 0.1]
for distance_threshold in distance_thresholds:
    print(f"Attempting plane segmentation with distance threshold: {distance_threshold}")
    plane_model, inliers = pcd.segment_plane(distance_threshold=distance_threshold, ransac_n=3, num_iterations=1000)
    floor = pcd.select_by_index(inliers)
    objects = pcd.select_by_index(inliers, invert=True)
    if len(inliers) > 0:
        print(f"Floor plane segmented with {len(inliers)} points. Proceeding with clustering.")
        break
    else:
        print("No floor plane found. Trying with a larger threshold.")

# If no floor is found, we will not proceed with clustering
if len(inliers) == 0:
    print("Unable to find the floor plane. Exiting.")
    exit()

# Perform clustering on the remaining points (DBSCAN)
# We use a small eps and a small number of min_points to start with
eps_values = [0.02, 0.05, 0.1, 0.2]
min_points_values = [10, 20, 30, 50]
for eps in eps_values:
    for min_points in min_points_values:
        print(f"Clustering with eps: {eps}, min_points: {min_points}")
        labels = np.array(objects.cluster_dbscan(eps=eps, min_points=min_points))
        if labels.max() < 0:
            print("No clusters found with these parameters.")
        else:
            print(f"Found {labels.max() + 1} clusters.")
            break
    if labels.max() >= 0:
        break

# Visualize the point cloud after floor removal
print("Visualizing the point cloud after floor removal:")
# o3d.visualization.draw_geometries([objects], point_show_normal=False)

# Calculate and visualize the bounding box for each cluster and print their dimensions
bounding_boxes = []
for i in range(labels.max() + 1):
    cluster_indices = np.where(labels == i)[0]
    cluster = objects.select_by_index(cluster_indices)
    aabb = cluster.get_axis_aligned_bounding_box()
    
    # Calculate dimensions of the bounding box (extent gives the width, height, and depth)
    dimensions = aabb.get_extent()
    
    # Filter out small bounding boxes
    if dimensions[0] < 0.1 and dimensions[1] < 0.1 and dimensions[2] < 0.1:
        # print(f"Object {i} is smaller than the threshold in all dimensions, ignoring.")
        continue
    
    aabb.color = np.random.uniform(0, 1, size=3)
    bounding_boxes.append(aabb)
    
    print(f"Object {i}:")
    print(f"  Width (x-axis): {dimensions[0]:.2f} units")
    print(f"  Depth (y-axis): {dimensions[1]:.2f} units")
    print(f"  Height (z-axis): {dimensions[2]:.2f} units\n")

print("Visualizing the clusters with bounding boxes:")
o3d.visualization.draw_geometries([objects, *bounding_boxes], point_show_normal=False)
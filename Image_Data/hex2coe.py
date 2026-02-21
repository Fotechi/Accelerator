-def hex_to_coe_blocked(hex_filename, coe_filename):
    # Step 1: Read and parse hex file
    with open(hex_filename, 'r') as f:
        hex_lines = f.readlines()
    
    # Convert lines to bytes (integers)
    data_bytes = [int(line.strip(), 16) for line in hex_lines if line.strip()]
    
    # Step 2: Ensure we have exactly 512 * 512 bytes     # change it 
    total_required = 512 * 512  # = 262144 bytes
    if len(data_bytes) < total_required:
        data_bytes.extend([0x00] * (total_required - len(data_bytes)))
    elif len(data_bytes) > total_required:
        data_bytes = data_bytes[:total_required]
    
    # Step 3: Group into 512-byte chunks
    elements = []
    for i in range(0, total_required, 512):
        chunk = data_bytes[i:i+512]
        # Convert to a single long hex string
        hex_chunk = ''.join(f"{byte:02X}" for byte in chunk)
        elements.append(hex_chunk)

    # Step 4: Write to COE file
    with open(coe_filename, 'w') as f:
        f.write("memory_initialization_radix=16;\n")
        f.write("memory_initialization_vector=\n")
        
        for idx, element in enumerate(elements):
            if idx < len(elements) - 1:
                f.write(f"{element},\n")
            else:
                f.write(f"{element};\n")  # Last line ends with ;

    print(f"COE file '{coe_filename}' successfully written with 512 elements of 512 bytes each.")
#To run
# hex_to_coe_blocked("BrickGray_2hexdigitsperline.hex", "BrickGray_4096_512_new.coe")

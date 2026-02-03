function gpumode
    switch "$argv[1]"
        case "--help"
            echo "Usage: gpumode [Integrated|Hybrid|VFIO|AsusEgpu|AsusMuxDgpu]"
            echo "Available modes:"
            echo "  Integrated"
            echo "  Hybrid"
            echo "  VFIO"
            echo "  AsusEgpu"
            echo "  AsusMuxDgpu"
        case "Integrated" "Hybrid" "VFIO" "AsusEgpu" "AsusMuxDgpu"
            supergfxctl --mode "$argv[1]"
        case ""
            echo "Error: No mode specified." >&2
            echo "Use 'gpumode --help' for available modes." >&2
            return 1
        case "*"
            echo "Error: Invalid mode '$argv[1]'." >&2
            echo "Use 'gpumode --help' for available modes." >&2
            return 1
    end
end

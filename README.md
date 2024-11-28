
# FishMaker2024

A SwiftUI-based light field image viewer for iOS. This application processes and displays light field images captured using a custom plano-convex lens array setup.

## Light Field Data Specifications

### Image Capture Setup
- Camera: Lumix GH3 with 20mm micro four thirds lens
- Raw image size: 4608 x 3456 (12MP)
- Image format: JPG

### Lens Array Properties
- Array dimensions: 82x73 lenslets physical array
- Visible in capture: ~80x60 lenslets
- Individual lens size: 1.6mm plano-convex
- Captured micro-lens-image (MLI) size: ~57-58 pixels per lenslet
- Known offsets: 8 pixels from left edge, 29 pixels from top edge
- Partial MLI visible in top row (approximately half visible)

### Working Volume Characteristics
- Effective volume: Approximately cubic, with lens array as one face
- Near features: Well-resolved with good depth discrimination
- Far features: Reduced detail due to limited angular resolution
- Best detail: Features nearer to lens array at time of capture

## Current Implementation

### Core Features
- Basic image loading and display
- Adjustable green grid overlay for lenslet visualization (adapted for color blindness)
- Pinch-to-zoom functionality for detailed inspection

### Grid Overlay System
- Starts at measured offsets (8px X, 29px Y)
- Attempts to match 57.5px horizontal and 57.1px vertical lenslet spacing
- Shows some drift due to lens distortion and perspective effects

### Known Issues
- Grid alignment drifts across image due to:
  - Lens distortion from 20mm M43 lens
  - Perspective effects from camera-array alignment
  - Possible mechanical variations in lens array
  - Need for proper calibration

## Future Development Plans

### Immediate Goals
- Implement proper lens array calibration
  - Fourier analysis for rotation detection
  - Template matching using distinctive diamond corner patterns
  - Account for barrel distortion and perspective effects

### Planned Features
- Real-time view angle rendering based on device motion
- Depth map generation using normalized cross correlation
- Variable patch size rendering for optimal detail
- Possible use of Metal for acceleration

### Future Hardware Support
- Potential expansion to 48MP iPhone 16 Pro Max capture
  - Would allow ~140x103 lenslets at current resolution
  - Or increased angular resolution with ~80-90 pixels per lenslet
  - Requires new lens array mount development

## Project History
- Based on previous implementation from 10 years ago on iPhone 6 Plus
- Successfully achieved real-time view angle rendering with motion sensing
- Previous version used Fourier analysis and template matching for calibration

## Code Organization
- Models/LightFieldData.swift: Core data structures and parameters
- Views/LightFieldView.swift: Main visualization interface
- ViewModels/LightFieldViewModel.swift: Image loading and processing
- Utils/ImageProcessing.swift: Image processing utilities

## Development Environment
- Target: iOS 16+
- Primary UI: SwiftUI
- Future processing: Metal API intended for optimization

## Technical Deep Dive

### Optical Configuration Specifics
- Working distance: Space between lens array and camera sensor influences MLI formation
- The 20mm M43 lens choice provides good working distance while maintaining resolution
- Each plano-convex lens forms a real image (unlike Lytro-style microlenses)
- System is more similar to "focused plenoptic camera" or "type 2.0" configuration
- MLI formation includes diamond-shaped artifacts at corners due to lens properties

### Key Algorithm Details
- Fourier Analysis for Rotation
  - Lens array creates strong frequency domain pattern
  - Grid pattern produces clear peaks in frequency space
  - More reliable than spatial domain analysis due to lens imperfections

- Template Matching Approach
  - Uses diamond corner patterns as registration features
  - These patterns are consistent across different captures
  - Provides sub-pixel accuracy for grid alignment

- Depth Estimation
  - Uses normalized cross correlation across multiple lenslets
  - Patch size varies with depth (larger for closer features)
  - Working volume constraints help bound the search space
  - Best results within cubic volume approximately array-width deep

### Light Field Sampling Properties
- Angular sampling: Limited by lens array precision and MLI resolution
- Spatial resolution: Traded off against angular sampling
- Effective resolution varies with depth
  - Near features: High spatial resolution, good angular sampling
  - Far features: Lower effective resolution due to parallax limitations

### Performance Considerations
- Memory management critical for 12MP+ images
- Original iPhone 6 Plus implementation achieved real-time rendering
- Modern Metal API can improve:
  - View synthesis speed
  - Depth estimation
  - Grid detection and calibration

### Calibration Process
1. Initial Grid Detection
   - Fourier analysis for global rotation
   - Edge detection for array boundaries
   - Offset measurement (8px, 29px) for grid origin

2. Local Refinement
   - Template matching at diamond corners
   - Accounts for local distortion
   - Handles partial lenslets at boundaries

3. Distortion Modeling
   - Barrel distortion from wide-angle lens
   - Perspective effects from non-parallel alignment
   - Local lens array variations

### View Synthesis Strategy
- Use depth information to adjust sampling
- Larger patches for well-resolved near features
- Blend between adjacent MLIs based on view angle
- Motion sensor data determines rendering parameters

### Critical Implementation Notes
- Each MLI is ~57-58 pixels: preserve full resolution
- Partial MLIs require special handling
- Grid alignment is crucial for proper reconstruction
- Real-time performance requires optimized sampling
- Memory bandwidth can be a bottleneck for full resolution

### Data Management
- Full 12MP images need careful memory handling
- Consider tiled processing for large arrays
- Cache rendered views for common angles
- Optimize depth map storage

### Known Limitations
- Angular resolution limited by lens quality
- Working volume constraints
- Edge MLIs may have artifacts
- Perspective effects need correction
- Processing overhead vs quality tradeoffs

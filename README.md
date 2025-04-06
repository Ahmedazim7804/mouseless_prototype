# Mouseless

Mouseless is a Flutter-based application designed to enhance productivity by enabling users to navigate and interact with their system layouts using only the keyboard. The app simulates a tiling window manager experience, allowing users to focus, move, and manage windows efficiently without relying on a mouse.

## Features

- **Tiling Window Management**: Simulate a tiling window manager layout with customizable layouts.
- **i3 Keybindings Integration**: Leverages actual keybindings from i3 to provide a realistic tiling window manager experience.
- **Real-Time Layout Updates**: Visualize changes to the layout as you interact with it.
- **Interactive Simulation**: Practice and master keyboard navigation through an interactive simulation environment.
- **Customizable Layouts**: Support for predefined layouts and the ability to modify them.

## Demo

## Getting Started

### Prerequisites

To run this project, ensure you have the following installed:

- i3 Window Manager (or any WM based on X11)
- [Flutter SDK](https://docs.flutter.dev/get-started/install)

### Installation

1. Go to the [Releases](https://github.com/Ahmedazim7804/mouseless_prototype) section of this repository.

2. Download the latest `.AppImage` file.

3. Make the file executable:

   ```bash
   chmod +x mouseless.AppImage
   ```

4. Run the AppImage:
   ```bash
   ./mouseless.AppImage
   ```

### Build from source

1. Clone the repository:

   ```bash
   git clone https://github.com/Ahmedazim7804/mouseless_prototype
   cd mouseless_prototype
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter build linux --release
   ```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

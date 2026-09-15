mod window;

use smithay::delegate_compositor;
use smithay::delegate_shm;
use smithay::delegate_seat;
use smithay::input::{SeatHandler, SeatState};
use smithay::reexports::wayland_server::backend::ClientData;
use smithay::reexports::wayland_server::protocol::wl_buffer::WlBuffer;
use smithay::reexports::wayland_server::protocol::wl_surface::WlSurface;
use smithay::reexports::wayland_server::Client;
use smithay::wayland::buffer::BufferHandler;
use smithay::wayland::compositor::{CompositorClientState, CompositorHandler, CompositorState};
use smithay::wayland::shm::{ShmHandler, ShmState};

#[derive(Default)]
pub struct CustomClientData {
    pub compositor_state: CompositorClientState,
}

impl ClientData for CustomClientData {}

pub struct SmallWmState {
    pub compositor_state: CompositorState,
    pub shm_state: ShmState,
    pub seat_state: SeatState<SmallWmState>,
}

impl CompositorHandler for SmallWmState {
    fn compositor_state(&mut self) -> &mut CompositorState {
        &mut self.compositor_state
    }

    fn client_compositor_state<'a>(&self, client: &'a Client) -> &'a CompositorClientState {
        &client
            .get_data::<CustomClientData>()
            .unwrap()
            .compositor_state
    }

    fn commit(&mut self, _surface: &WlSurface) {}
}

impl BufferHandler for SmallWmState {
    fn buffer_destroyed(&mut self, _buffer: &WlBuffer) {}
}

impl ShmHandler for SmallWmState {
    fn shm_state(&self) -> &ShmState {
        &self.shm_state
    }
}

impl SeatHandler for SmallWmState {
    type KeyboardFocus = WlSurface;
    type PointerFocus = WlSurface;
    type TouchFocus = WlSurface;

    fn seat_state(&mut self) -> &mut SeatState<Self> {
        &mut self.seat_state
    }

    fn focus_changed(&mut self, _seat: &smithay::input::Seat<Self>, _focus: Option<&WlSurface>) {}
    fn cursor_image(&mut self, _seat: &smithay::input::Seat<Self>, _image: smithay::input::pointer::CursorImageStatus) {}
}

delegate_seat!(SmallWmState);
delegate_compositor!(SmallWmState);
delegate_shm!(SmallWmState);

fn main() {
    window::run_window();
}

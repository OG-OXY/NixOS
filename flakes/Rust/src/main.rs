use smithay::backend::renderer::glow::GlowRenderer;
use smithay::delegate_compositor;
use smithay::delegate_shm;
use smithay::reexports::wayland_server::backend::ClientData;
use smithay::reexports::wayland_server::protocol::wl_buffer::WlBuffer;
use smithay::reexports::wayland_server::protocol::wl_surface::WlSurface;
use smithay::reexports::wayland_server::{Client, Display};
use smithay::wayland::buffer::BufferHandler;
use smithay::wayland::compositor::{
    CompositorClientState, CompositorHandler, CompositorState,
};
use smithay::wayland::shm::{ShmHandler, ShmState};

#[derive(Default)]
pub struct CustomClientData {
    pub compositor_state: CompositorClientState,
}

impl ClientData for CustomClientData {}

pub struct SmallWmState {
    pub compositor_state: CompositorState,
    pub shm_state: ShmState,
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

delegate_compositor!(SmallWmState);
delegate_shm!(SmallWmState);

fn main() {
    let display: Display<SmallWmState> = Display::new().unwrap();
    let dh = display.handle();

    let compositor_state = CompositorState::new::<SmallWmState>(&dh);
    let shm_state = ShmState::new::<SmallWmState>(&dh, vec![]);

    let _state = SmallWmState {
        compositor_state,
        shm_state,
    };

    let _ = std::mem::size_of::<GlowRenderer>();

    println!("Smithay setup initialized successfully.");
}

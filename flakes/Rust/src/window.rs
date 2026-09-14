use crate::SmallWmState;
use smithay::backend::renderer::gles::GlesRenderer; // Import GlesRenderer
use smithay::backend::winit;
use smithay::input::SeatState;
use smithay::reexports::calloop::EventLoop;
use smithay::reexports::wayland_server::Display;
use smithay::wayland::compositor::CompositorState;
use smithay::wayland::shm::ShmState;

pub fn run_window() {
    let mut event_loop: EventLoop<SmallWmState> = EventLoop::try_new().unwrap();
    let display: Display<SmallWmState> = Display::new().unwrap();
    let dh = display.handle();

    let compositor_state = CompositorState::new::<SmallWmState>(&dh);
    let shm_state = ShmState::new::<SmallWmState>(&dh, vec![]);
    let seat_state = SeatState::new();

    let mut state = SmallWmState {
        compositor_state,
        shm_state,
        seat_state,
    };

    // Pass GlesRenderer here instead of SmallWmState
    let (_backend, winit_event_source) = winit::init::<GlesRenderer>().unwrap();

    event_loop
        .handle()
        .insert_source(winit_event_source, move |_event, _, _state| {
            // Winit window events go here
        })
        .unwrap();

    println!("Smithay winit backend initialized. Starting event loop...");

    event_loop
        .run(std::time::Duration::from_millis(16), &mut state, |_state| {
            // Periodic tick logic (~60 FPS)
        })
        .unwrap();
}

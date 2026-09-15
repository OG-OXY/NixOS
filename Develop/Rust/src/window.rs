use crate::SmallWmState;
use std::cell::RefCell;
use std::rc::Rc;
use smithay::backend::renderer::gles::GlesRenderer;
use smithay::backend::renderer::Renderer;
use smithay::backend::winit::{self, WinitEvent};
use smithay::input::SeatState;
use smithay::reexports::calloop::EventLoop;
use smithay::reexports::wayland_server::Display;
use smithay::utils::{Rectangle, Transform};
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

    let (backend, winit_event_source) = winit::init::<GlesRenderer>().unwrap();
    let backend = Rc::new(RefCell::new(backend));

    backend.borrow_mut().window().request_redraw();

    let backend_clone = backend.clone();
    event_loop
        .handle()
        .insert_source(winit_event_source, move |event, _, state| {
            let mut backend = backend_clone.borrow_mut();
            match event {
                WinitEvent::Resized { size, scale_factor, .. } => {
                    backend.window().request_redraw();
                    let _ = (size, scale_factor);
                }
                WinitEvent::Input(event) => {
                    let _ = (event, state);
                }
                WinitEvent::CloseRequested => {
                    std::process::exit(0);
                }
                _ => {}
            }
        })
        .unwrap();

    println!("Smithay winit backend initialized. Starting event loop...");

    event_loop
        .run(std::time::Duration::from_millis(16), &mut state, |_state| {
            let mut backend = backend.borrow_mut();
            let size = backend.window_size();
            let damage = Rectangle::from_size(size);

            if let Ok((renderer, mut fb)) = backend.bind() {
                if let Ok(mut frame) = renderer.render(&mut fb, size, Transform::Normal) {
                    let _ = frame.clear([0.1, 0.1, 0.1, 1.0], &[damage]);
                }
                let _ = backend.submit(Some(&[damage]));
            }
            backend.window().request_redraw();
        })
        .unwrap();
}

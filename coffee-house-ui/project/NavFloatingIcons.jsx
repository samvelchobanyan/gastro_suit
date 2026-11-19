
/**
 * NavFloatingIcons — icon-only NavFloating: same floating pill, themes, sliding
 * selection pill and squash/pop motion, no labels; icons 24px (--icon-md).
 * Each item's `label` is kept as the button's aria-label.
 *
 * Based on NavFloating — floating pill bottom navigation. Sits over screen content,
 * inset --space-base from left, right and bottom (+ safe area). A sliding
 * selection pill glides to the active item with a springy overshoot and a
 * brief squash-and-stretch; the newly active icon pops. Place inside a
 * position:relative screen container (or pass position="fixed").
 */
function NavFloatingIcons({
  items = [],          // [{ key, icon, label, badge }]
  activeKey = null,
  onChange = () => {},
  position = 'absolute',
  theme = 'dark',      // 'dark' | 'light'
}) {
  const light = theme === 'light';
  const navRef = React.useRef(null);
  const pillRef = React.useRef(null);
  const btnRefs = React.useRef({});
  const iconRefs = React.useRef({});
  const prevKey = React.useRef(activeKey);
  const [rect, setRect] = React.useState(null);

  const measure = React.useCallback(() => {
    const b = btnRefs.current[activeKey];
    if (b) setRect({ x: b.offsetLeft, w: b.offsetWidth });
  }, [activeKey]);

  React.useLayoutEffect(() => { measure(); }, [measure, items.length]);
  React.useEffect(() => {
    if (!navRef.current || typeof ResizeObserver === 'undefined') return;
    const ro = new ResizeObserver(measure);
    ro.observe(navRef.current);
    return () => ro.disconnect();
  }, [measure]);

  React.useEffect(() => {
    if (prevKey.current === activeKey) return;
    const reduce = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    if (!reduce) {
      const pill = pillRef.current;
      if (pill && pill.animate) {
        pill.animate(
          [{ scale: '1 1' }, { scale: '1.12 0.9', offset: 0.35 }, { scale: '0.97 1.03', offset: 0.7 }, { scale: '1 1' }],
          { duration: 400, easing: 'ease-out' }
        );
      }
      const icon = iconRefs.current[activeKey];
      if (icon && icon.animate) {
        icon.animate(
          [{ transform: 'scale(1)' }, { transform: 'scale(0.82)', offset: 0.3 }, { transform: 'scale(1.12)', offset: 0.65 }, { transform: 'scale(1)' }],
          { duration: 400, easing: 'ease-out' }
        );
      }
    }
    prevKey.current = activeKey;
  }, [activeKey]);

  return (
    <div style={{
      position, left: 'var(--space-base)', right: 'var(--space-base)',
      bottom: 'calc(var(--space-base) + env(safe-area-inset-bottom, 0px))',
      zIndex: 10, pointerEvents: 'none', display: 'flex', justifyContent: 'center',
    }}>
      <nav ref={navRef} aria-label="Primary" style={{
        position: 'relative', pointerEvents: 'auto', width: '100%', boxSizing: 'border-box',
        display: 'flex', alignItems: 'stretch', padding: 'var(--space-xs)',
        height: 'var(--bottomnav-height-labeled)', borderRadius: 'var(--radius-full)',
        background: light ? 'var(--gray-0)' : 'var(--gray-800)',
        boxShadow: 'var(--shadow-sm)', fontFamily: 'var(--font-family-base)',
      }}>
        {rect && (
          <span ref={pillRef} aria-hidden="true" style={{
            position: 'absolute', top: 'var(--space-xs)', bottom: 'var(--space-xs)', left: 0,
            width: rect.w, transform: `translateX(${rect.x}px)`,
            borderRadius: 'var(--radius-full)', background: 'var(--gray-50)',
            transition: 'transform var(--duration-slower) var(--ease-emphasized), width var(--duration-slower) var(--ease-emphasized)',
          }} />
        )}
        {items.map((it) => {
          const active = it.key === activeKey;
          return (
            <button
              key={it.key} ref={(el) => { btnRefs.current[it.key] = el; }}
              type="button" onClick={() => onChange(it.key)} aria-current={active ? 'page' : undefined} aria-label={it.label}
              style={{
                position: 'relative', flex: 1, minWidth: 0, display: 'flex', flexDirection: 'column',
                alignItems: 'center', justifyContent: 'center',
                border: 'none', background: 'transparent', padding: 0, cursor: 'pointer',
                color: active ? 'var(--bottomnav-icon-active)' : (light ? 'var(--gray-800)' : 'var(--gray-0)'),
                WebkitTapHighlightColor: 'transparent', transition: 'var(--transition-colors)',
              }}
            >
              <span ref={(el) => { iconRefs.current[it.key] = el; }} style={{ position: 'relative', display: 'inline-flex' }}>
                <i className={`${active ? 'ph-fill' : 'ph'} ph-${it.icon}`} aria-hidden="true" style={{ fontSize: 'var(--icon-md)' }} />
                {it.badge != null && (
                  <span style={{
                    position: 'absolute', top: 'calc(var(--space-xs) * -1)', right: 'calc(var(--space-sm) * -1)',
                    minWidth: 'var(--icon-xs)', height: 'var(--icon-xs)', padding: '0 var(--space-xs)', boxSizing: 'border-box',
                    display: 'inline-flex', alignItems: 'center', justifyContent: 'center',
                    background: 'var(--badge-bg)', color: 'var(--badge-text)', borderRadius: 'var(--radius-full)',
                    font: 'var(--text-body-xs)', fontWeight: 'var(--font-weight-bold)',
                  }}>{it.badge}</span>
                )}
              </span>
            </button>
          );
        })}
      </nav>
    </div>
  );
}

module.exports = { NavFloatingIcons };

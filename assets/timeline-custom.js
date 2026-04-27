/* Timeline custom — APER Bolivia 2026
 * Componente nativo en JavaScript vanilla, sin dependencias externas.
 * Lee timeline.json (formato KnightLab) y renderiza:
 *  - Línea horizontal navegable con dots
 *  - Panel de detalle con imagen + descripción
 *  - Filtros por categoría
 *  - Búsqueda por texto
 *  - Navegación con flechas del teclado
 */
(function () {
  'use strict';

  const APP_ID = 'tl-app';
  const DATA_URL = 'timeline.json';

  // Mapeo de URLs externas Wikimedia a copias locales (cuando sea posible)
  // Heurística: si una URL externa falla, fallback a placeholder.
  function resolveImageUrl(extUrl) {
    if (!extUrl) return null;
    // Si ya es ruta relativa local, dejar tal cual
    if (extUrl.startsWith('figures/') || extUrl.startsWith('./')) return extUrl;
    return extUrl;
  }

  function formatDate(d) {
    if (!d) return '';
    const months = ['', 'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
                    'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre'];
    if (d.day && d.month) return `${d.day} ${months[d.month]} ${d.year}`;
    if (d.month) return `${months[d.month]} ${d.year}`;
    return String(d.year);
  }

  function formatRange(start, end) {
    if (!end) return formatDate(start);
    return `${formatDate(start)} – ${formatDate(end)}`;
  }

  // Posición horizontal proporcional al año (con sub-año para mes)
  function timeToPos(date, minYear, maxYear) {
    let y = date.year;
    if (date.month) y += (date.month - 1) / 12;
    if (date.day) y += date.day / 365;
    return ((y - minYear) / (maxYear - minYear)) * 100;
  }

  function init(events, titleEvent) {
    const container = document.getElementById(APP_ID);
    if (!container) return;

    // Indexar eventos
    events.forEach((ev, i) => { ev._idx = i; });

    // Determinar rango temporal
    const years = events.map(e => e.start_date.year);
    const minYear = Math.floor(Math.min(...years) / 5) * 5;
    const maxYear = Math.ceil(Math.max(...years) / 5) * 5;

    // Categorías y conteo
    const groups = {};
    events.forEach(e => {
      const g = e.group || 'Otros';
      groups[g] = (groups[g] || 0) + 1;
    });

    // Eras políticas (líneas verticales en el track)
    const eras = [
      { label: 'Pre-MAS',     yearStart: minYear, yearEnd: 2005 },
      { label: 'Era Morales', yearStart: 2006,    yearEnd: 2019 },
      { label: 'Áñez + Arce', yearStart: 2020,    yearEnd: maxYear }
    ];

    // ── Build DOM ──────────────────────────────────────────────────────────
    container.innerHTML = '';

    // Filtros
    const controls = document.createElement('div');
    controls.className = 'tl-controls';
    controls.innerHTML = `<span class="tl-filter-label">Filtrar</span>`;

    const filterTotal = document.createElement('button');
    filterTotal.className = 'tl-filter active';
    filterTotal.dataset.group = '__all__';
    filterTotal.innerHTML = `Todos <span class="tl-count">${events.length}</span>`;
    controls.appendChild(filterTotal);

    Object.keys(groups).sort().forEach(g => {
      const btn = document.createElement('button');
      btn.className = 'tl-filter';
      btn.dataset.group = g;
      btn.innerHTML = `${g} <span class="tl-count">${groups[g]}</span>`;
      controls.appendChild(btn);
    });

    const search = document.createElement('input');
    search.type = 'search';
    search.className = 'tl-search';
    search.placeholder = 'Buscar hito…';
    search.setAttribute('aria-label', 'Buscar en hitos');
    controls.appendChild(search);

    container.appendChild(controls);

    // Panel detalle
    const detail = document.createElement('div');
    detail.className = 'tl-detail';
    container.appendChild(detail);

    // Track de navegación
    const nav = document.createElement('div');
    nav.className = 'tl-nav';

    const navTrack = document.createElement('div');
    navTrack.className = 'tl-nav-track';
    nav.appendChild(navTrack);

    const navInner = document.createElement('div');
    navInner.className = 'tl-nav-inner';
    navInner.style.width = `${(maxYear - minYear) * 28}px`; // 28 px por año
    navInner.style.minWidth = '100%';
    navTrack.appendChild(navInner);

    // Línea horizontal
    const line = document.createElement('div');
    line.className = 'tl-nav-line';
    navInner.appendChild(line);

    // Marcas de año
    for (let y = minYear; y <= maxYear; y++) {
      const mark = document.createElement('div');
      mark.className = 'tl-year-mark' + (y % 5 === 0 ? ' major' : '');
      mark.style.left = `${timeToPos({year: y, month: 1, day: 1}, minYear, maxYear)}%`;
      navInner.appendChild(mark);
      if (y % 5 === 0) {
        const label = document.createElement('div');
        label.className = 'tl-year-label';
        label.textContent = y;
        label.style.left = `${timeToPos({year: y, month: 1, day: 1}, minYear, maxYear)}%`;
        navInner.appendChild(label);
      }
    }

    // Bandas de gobierno
    eras.forEach((era, i) => {
      const band = document.createElement('div');
      band.className = 'tl-era-band' + (i === 0 ? ' first' : '');
      band.style.left = `${timeToPos({year: era.yearStart, month: 1, day: 1}, minYear, maxYear)}%`;
      band.style.width = `${timeToPos({year: era.yearEnd + 1, month: 1, day: 1}, minYear, maxYear) - timeToPos({year: era.yearStart, month: 1, day: 1}, minYear, maxYear)}%`;
      navInner.appendChild(band);

      const eraLabel = document.createElement('div');
      eraLabel.className = 'tl-era-label';
      eraLabel.textContent = era.label;
      eraLabel.style.left = `calc(${timeToPos({year: era.yearStart, month: 1, day: 1}, minYear, maxYear)}% + 6px)`;
      navInner.appendChild(eraLabel);
    });

    // Dots de hitos
    const dots = [];
    events.forEach((ev, i) => {
      const dot = document.createElement('div');
      dot.className = 'tl-dot';
      dot.dataset.group = ev.group || 'Otros';
      dot.dataset.idx = i;
      dot.style.left = `${timeToPos(ev.start_date, minYear, maxYear)}%`;

      // Aleatorizar levemente la posición vertical para evitar superposición exacta
      const verticalOffset = (i % 3 - 1) * 8;
      dot.style.top = `calc(50% + ${verticalOffset}px)`;

      // Tooltip
      const tip = document.createElement('div');
      tip.className = 'tl-tooltip';
      tip.textContent = `${ev.start_date.year} · ${ev.text.headline}`;
      dot.appendChild(tip);

      navInner.appendChild(dot);
      dots.push(dot);
    });

    container.appendChild(nav);

    // Indicador de progreso + navegación
    const progress = document.createElement('div');
    progress.className = 'tl-progress';
    progress.innerHTML = `
      <span class="tl-progress-counter" id="tl-counter">— / ${events.length}</span>
      <div class="tl-nav-buttons">
        <button class="tl-nav-btn" id="tl-prev" aria-label="Hito anterior">← Anterior</button>
        <button class="tl-nav-btn" id="tl-next" aria-label="Siguiente hito">Siguiente →</button>
      </div>
    `;
    container.appendChild(progress);

    // ── Estado y rendering ─────────────────────────────────────────────────
    let activeIdx = 0;
    let activeFilter = '__all__';
    let searchQuery = '';

    function eventVisible(ev) {
      if (activeFilter !== '__all__' && (ev.group || 'Otros') !== activeFilter) return false;
      if (searchQuery) {
        const q = searchQuery.toLowerCase();
        const haystack = (ev.text.headline + ' ' + (ev.text.text || '') + ' ' + (ev.tag || '')).toLowerCase();
        if (!haystack.includes(q)) return false;
      }
      return true;
    }

    function applyFilters() {
      events.forEach((ev, i) => {
        dots[i].classList.toggle('hidden', !eventVisible(ev));
      });
      // Si el activo está oculto, ir al primero visible
      if (!eventVisible(events[activeIdx])) {
        const firstVisible = events.findIndex(eventVisible);
        if (firstVisible >= 0) showEvent(firstVisible);
        else renderEmpty();
      }
    }

    function renderEmpty() {
      detail.innerHTML = `<div class="tl-detail-empty">Sin resultados con los filtros actuales.</div>`;
      document.getElementById('tl-counter').textContent = `0 / ${events.length}`;
    }

    function showEvent(idx) {
      activeIdx = idx;
      const ev = events[idx];

      dots.forEach((d, i) => d.classList.toggle('active', i === idx));

      // Scroll suave al dot activo si está fuera de la vista
      const dot = dots[idx];
      const rect = dot.getBoundingClientRect();
      const trackRect = navTrack.getBoundingClientRect();
      if (rect.left < trackRect.left + 100 || rect.right > trackRect.right - 100) {
        const target = dot.offsetLeft - navTrack.clientWidth / 2 + dot.offsetWidth / 2;
        navTrack.scrollTo({ left: target, behavior: 'smooth' });
      }

      // Detalle
      const imgUrl = ev.media && ev.media.url ? resolveImageUrl(ev.media.url) : null;
      const headline = ev.text.headline || '(sin título)';
      // Limpiar HTML básico: convertir <br> y <strong> seguros
      const text = (ev.text.text || '').replace(/<\/?(?!br\b|strong\b|em\b|a\b|code\b)[^>]+>/gi, '');

      const dateLabel = formatRange(ev.start_date, ev.end_date);
      const groupLabel = ev.group || 'Otros';

      detail.innerHTML = `
        ${imgUrl
          ? `<img class="tl-detail-image" src="${imgUrl}" alt="${headline}" loading="lazy" onerror="this.outerHTML='<div class=&quot;tl-detail-image-placeholder&quot;>Sin imagen</div>'">`
          : `<div class="tl-detail-image-placeholder">Sin imagen</div>`}
        <div>
          <div class="tl-detail-meta">
            <span class="tl-detail-date">${dateLabel}</span>
            <span class="tl-detail-group">${groupLabel}</span>
          </div>
          <h3 class="tl-detail-headline">${headline}</h3>
          <div class="tl-detail-text">${text}</div>
          ${ev.media && (ev.media.credit || ev.media.caption)
            ? `<div class="tl-detail-credit">${[ev.media.caption, ev.media.credit].filter(Boolean).join(' — ')}</div>`
            : ''}
        </div>
      `;

      // Counter
      const visibleEvents = events.filter(eventVisible);
      const visibleIdx = visibleEvents.indexOf(ev) + 1;
      document.getElementById('tl-counter').textContent =
        `${visibleIdx} / ${visibleEvents.length}` +
        (visibleEvents.length < events.length ? ` (${events.length} total)` : '');

      // Estado botones nav
      document.getElementById('tl-prev').disabled = visibleIdx <= 1;
      document.getElementById('tl-next').disabled = visibleIdx >= visibleEvents.length;
    }

    function navStep(direction) {
      const visibleEvents = events.map((e, i) => eventVisible(e) ? i : -1).filter(i => i >= 0);
      const currentVisIdx = visibleEvents.indexOf(activeIdx);
      const nextIdx = currentVisIdx + direction;
      if (nextIdx >= 0 && nextIdx < visibleEvents.length) {
        showEvent(visibleEvents[nextIdx]);
      }
    }

    // ── Wire events ────────────────────────────────────────────────────────
    dots.forEach((d, i) => {
      d.addEventListener('click', () => showEvent(i));
    });

    controls.querySelectorAll('.tl-filter').forEach(btn => {
      btn.addEventListener('click', () => {
        controls.querySelectorAll('.tl-filter').forEach(b => b.classList.remove('active'));
        btn.classList.add('active');
        activeFilter = btn.dataset.group;
        applyFilters();
      });
    });

    let searchTimer;
    search.addEventListener('input', () => {
      clearTimeout(searchTimer);
      searchTimer = setTimeout(() => {
        searchQuery = search.value.trim();
        applyFilters();
      }, 150);
    });

    document.getElementById('tl-prev').addEventListener('click', () => navStep(-1));
    document.getElementById('tl-next').addEventListener('click', () => navStep(1));

    document.addEventListener('keydown', (e) => {
      // Solo si el componente está visible y el foco no está en input
      if (document.activeElement === search) return;
      const rect = container.getBoundingClientRect();
      if (rect.bottom < 0 || rect.top > window.innerHeight) return;

      if (e.key === 'ArrowLeft') { e.preventDefault(); navStep(-1); }
      else if (e.key === 'ArrowRight') { e.preventDefault(); navStep(1); }
    });

    // Estado inicial: mostrar primer hito
    showEvent(0);
  }

  // ── Bootstrap ────────────────────────────────────────────────────────────
  function boot() {
    const container = document.getElementById(APP_ID);
    if (!container) return;
    container.innerHTML = '<div class="tl-loading">Cargando línea de tiempo…</div>';

    fetch(DATA_URL)
      .then(r => {
        if (!r.ok) throw new Error('HTTP ' + r.status);
        return r.json();
      })
      .then(data => {
        const events = data.events || [];
        const titleEvent = data.title || null;
        if (events.length === 0) {
          container.innerHTML = '<div class="tl-loading">No hay eventos disponibles.</div>';
          return;
        }
        // Orden por fecha
        events.sort((a, b) => {
          const ya = a.start_date.year + (a.start_date.month || 0) / 12;
          const yb = b.start_date.year + (b.start_date.month || 0) / 12;
          return ya - yb;
        });
        init(events, titleEvent);
      })
      .catch(err => {
        console.error('Error cargando timeline:', err);
        container.innerHTML =
          '<div class="tl-loading">' +
          'No fue posible cargar la línea de tiempo. ' +
          '<a href="downloads/timeline.csv">Descargar el CSV original</a>.' +
          '</div>';
      });
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', boot);
  } else {
    boot();
  }
})();

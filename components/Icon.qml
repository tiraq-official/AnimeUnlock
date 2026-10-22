import QtQuick 2.11

//
// Icon — tiny vector icons drawn on a Canvas so the theme needs no icon
// font and no external assets.
//
//   name : "power" | "restart" | "moon" | "lock" | "chevron" | "arrow"
//          "person" | "monitor" | "weather"
//
Item {
    id: icon
    property string name: "power"
    property color color: "#ffffff"
    property real lineWidth: Math.max(1.6, Math.min(width, height) * 0.085)

    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true
        onPaint: icon.paint(canvas.getContext("2d"), canvas.width, canvas.height)
    }

    onNameChanged:  canvas.requestPaint()
    onColorChanged: canvas.requestPaint()
    onWidthChanged: canvas.requestPaint()
    onHeightChanged:canvas.requestPaint()

    function paint(ctx, w, h) {
        ctx.clearRect(0, 0, w, h);
        if (w <= 0 || h <= 0) return;

        ctx.strokeStyle = icon.color;
        ctx.fillStyle   = icon.color;
        ctx.lineWidth   = icon.lineWidth;
        ctx.lineCap     = "round";
        ctx.lineJoin    = "round";

        var cx = w / 2;
        var cy = h / 2;
        var r  = Math.min(w, h) * 0.33;
        var n  = icon.name;

        if (n === "power") {
            ctx.beginPath();
            ctx.arc(cx, cy + r * 0.08, r, -Math.PI / 2 + 0.62, -Math.PI / 2 + Math.PI * 2 - 0.62);
            ctx.stroke();
            ctx.beginPath();
            ctx.moveTo(cx, cy - r * 1.45);
            ctx.lineTo(cx, cy - r * 0.18);
            ctx.stroke();

        } else if (n === "restart") {
            var a0 = -Math.PI * 0.30;
            var a1 = Math.PI * 1.02;
            ctx.beginPath();
            ctx.arc(cx, cy, r, a0, a1);
            ctx.stroke();
            var ex = cx + r * Math.cos(a1);
            var ey = cy + r * Math.sin(a1);
            var t  = r * 0.62;
            ctx.beginPath();
            ctx.moveTo(ex - t * 0.75, ey - t * 0.40);
            ctx.lineTo(ex + t * 0.50, ey - t * 0.05);
            ctx.lineTo(ex - t * 0.05, ey + t * 0.75);
            ctx.closePath();
            ctx.fill();

        } else if (n === "moon") {
            ctx.beginPath();
            ctx.arc(cx + r * 0.18, cy, r * 0.95, Math.PI * 0.45, Math.PI * 1.55);
            ctx.arc(cx + r * 0.72, cy, r * 1.02, Math.PI * 1.55, Math.PI * 0.45, true);
            ctx.closePath();
            ctx.fill();

        } else if (n === "lock") {
            ctx.beginPath();
            ctx.arc(cx, cy - r * 0.42, r * 0.46, Math.PI, Math.PI * 2);
            ctx.stroke();
            ctx.beginPath();
            ctx.rect(cx - r * 0.68, cy - r * 0.02, r * 1.36, r * 1.02);
            ctx.stroke();

        } else if (n === "chevron") {
            ctx.beginPath();
            ctx.moveTo(cx - r * 0.75, cy - r * 0.28);
            ctx.lineTo(cx,            cy + r * 0.42);
            ctx.lineTo(cx + r * 0.75, cy - r * 0.28);
            ctx.stroke();

        } else if (n === "arrow") {
            ctx.beginPath();
            ctx.moveTo(cx - r * 0.62, cy);
            ctx.lineTo(cx + r * 0.52, cy);
            ctx.stroke();
            ctx.beginPath();
            ctx.moveTo(cx + r * 0.05, cy - r * 0.52);
            ctx.lineTo(cx + r * 0.64, cy);
            ctx.lineTo(cx + r * 0.05, cy + r * 0.52);
            ctx.stroke();

        } else if (n === "person") {
            ctx.beginPath();
            ctx.arc(cx, cy - r * 0.42, r * 0.46, 0, Math.PI * 2);
            ctx.fill();
            ctx.beginPath();
            ctx.arc(cx, cy + r * 1.05, r * 0.78, Math.PI * 1.08, Math.PI * 1.92);
            ctx.fill();

        } else if (n === "monitor") {
            ctx.beginPath();
            ctx.rect(cx - r * 0.85, cy - r * 0.72, r * 1.70, r * 1.15);
            ctx.stroke();
            ctx.beginPath();
            ctx.moveTo(cx, cy + r * 0.43);
            ctx.lineTo(cx, cy + r * 0.85);
            ctx.stroke();
            ctx.beginPath();
            ctx.moveTo(cx - r * 0.45, cy + r * 0.85);
            ctx.lineTo(cx + r * 0.45, cy + r * 0.85);
            ctx.stroke();

        } else if (n === "weather") {
            ctx.beginPath();
            ctx.arc(cx - r * 0.45, cy + r * 0.18, r * 0.42, Math.PI * 0.5, Math.PI * 1.5);
            ctx.stroke();
            ctx.beginPath();
            ctx.arc(cx - r * 0.12, cy - r * 0.12, r * 0.52, Math.PI * 1.02, Math.PI * 1.98);
            ctx.stroke();
            ctx.beginPath();
            ctx.arc(cx + r * 0.45, cy + r * 0.18, r * 0.42, Math.PI * 1.5, Math.PI * 0.5);
            ctx.stroke();
            ctx.beginPath();
            ctx.moveTo(cx - r * 0.45, cy + r * 0.60);
            ctx.lineTo(cx + r * 0.45, cy + r * 0.60);
            ctx.stroke();
        }
    }
}

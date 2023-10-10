struct VecBigInt256 {
    limbs: array<vec4<u32>, 4>
}

const shift_c0: vec4<u32> = vec4<u32>(1u, 2u, 3u, 4u);
const shift_c1: vec4<u32> = vec4<u32>(5u, 6u, 7u, 8u);
const shift_c2: vec4<u32> = vec4<u32>(9u, 10u, 11u, 12u);
const shift_c3: vec4<u32> = vec4<u32>(13u, 14u, 15u, 16u);
const shift_m0: vec4<u32> = vec4<u32>(0u, 1u, 2u, 3u);
const shift_m1: vec4<u32> = vec4<u32>(4u, 5u, 6u, 7u);
const shift_m2: vec4<u32> = vec4<u32>(8u, 9u, 10u, 11u);
const shift_m3: vec4<u32> = vec4<u32>(12u, 13u, 14u, 15u);
const p0: vec4<u32> = vec4<u32>(1u, 61440u, 62867u, 17377u);
const p1: vec4<u32> = vec4<u32>(28817u, 31161u, 59464u, 10291u);
const p2: vec4<u32> = vec4<u32>(22621u, 33153u, 17846u, 47184u);
const p3: vec4<u32> = vec4<u32>(41001u, 57649u, 20082u, 12388u);

fn vec_bigint_add(
    a: ptr<function, VecBigInt256>,
    b: ptr<function, VecBigInt256>,
    res: ptr<function, VecBigInt256>) -> u32 {
    let s0 = (*a).limbs[0u] + (*b).limbs[0u];
    let cvec0 = (s0 / 0x10000u) << shift_c0;
    let mvec0 = (((s0 % 0x10000u) + 1u) / 0x10000u) << shift_m0;
    let s1 = (*a).limbs[1u] + (*b).limbs[1u];
    let cvec1 = (s1 / 0x10000u) << shift_c1;
    let mvec1 = (((s1 % 0x10000u) + 1u) / 0x10000u) << shift_m1;
    let s2 = (*a).limbs[2u] + (*b).limbs[2u];
    let cvec2 = (s2 / 0x10000u) << shift_c2;
    let mvec2 = (((s2 % 0x10000u) + 1u) / 0x10000u) << shift_m2;
    let s3 = (*a).limbs[3u] + (*b).limbs[3u];
    let cvec3 = (s3 / 0x10000u) << shift_c3;
    let mvec3 = (((s3 % 0x10000u) + 1u) / 0x10000u) << shift_m3;

    var c: u32 = cvec3.x | cvec3.y | cvec3.z | cvec3.w |
        cvec2.x | cvec2.y | cvec2.z | cvec2.w |
        cvec1.x | cvec1.y | cvec1.z | cvec1.w |
        cvec0.x | cvec0.y | cvec0.z | cvec0.w;
    var m: u32 = mvec3.x | mvec3.y | mvec3.z | mvec3.w |
        mvec2.x | mvec2.y | mvec2.z | mvec2.w |
        mvec1.x | mvec1.y | mvec1.z | mvec1.w |
        mvec0.x | mvec0.y | mvec0.z | mvec0.w;

    c += m;
    m ^= c;
    let mask0 = (vec4<u32>(m, m >> 1u, m >> 2u, m >> 3u) % 2u) * 0xFFFFu;
    let mask1 = (vec4<u32>(m >> 4u, m >> 5u, m >> 6u, m >> 7u) % 2u) * 0xFFFFu;
    let mask2 = (vec4<u32>(m >> 8u, m >> 9u, m >> 10u, m >> 11u) % 2u) * 0xFFFFu;
    let mask3 = (vec4<u32>(m >> 12u, m >> 13u, m >> 14u, m >> 15u) % 2u) * 0xFFFFu;
    (*res).limbs[0] = (s0 - mask0) % 0x10000u;
    (*res).limbs[1] = (s1 - mask1) % 0x10000u;
    (*res).limbs[2] = (s2 - mask2) % 0x10000u;
    (*res).limbs[3] = (s3 - mask3) % 0x10000u;
    return c >> 16u;
}

fn vec_bigint_sub(
    a: ptr<function, VecBigInt256>,
    b: ptr<function, VecBigInt256>,
    res: ptr<function, VecBigInt256>) -> u32 {
    let s0 = (*a).limbs[0u] - (*b).limbs[0u];
    let cvec0 = (s0 / 0x80000000u) << shift_c0;
    let mvec0 = (((s0 % 0x80000000u) - 1u) / 0x80000000u) << shift_m0;
    let s1 = (*a).limbs[1u] - (*b).limbs[1u];
    let cvec1 = (s1 / 0x80000000u) << shift_c1;
    let mvec1 = (((s1 % 0x80000000u) - 1u) / 0x80000000u) << shift_m1;
    let s2 = (*a).limbs[2u] - (*b).limbs[2u];
    let cvec2 = (s2 / 0x80000000u) << shift_c2;
    let mvec2 = (((s2 % 0x80000000u) - 1u) / 0x80000000u) << shift_m2;
    let s3 = (*a).limbs[3u] - (*b).limbs[3u];
    let cvec3 = (s3 / 0x80000000u) << shift_c3;
    let mvec3 = (((s3 % 0x80000000u) - 1u) / 0x80000000u) << shift_m3;
    var c: u32 = cvec3.x | cvec3.y | cvec3.z | cvec3.w |
        cvec2.x | cvec2.y | cvec2.z | cvec2.w |
        cvec1.x | cvec1.y | cvec1.z | cvec1.w |
        cvec0.x | cvec0.y | cvec0.z | cvec0.w;
    var m: u32 = mvec3.x | mvec3.y | mvec3.z | mvec3.w |
        mvec2.x | mvec2.y | mvec2.z | mvec2.w |
        mvec1.x | mvec1.y | mvec1.z | mvec1.w |
        mvec0.x | mvec0.y | mvec0.z | mvec0.w;

    c += m;
    m ^= c;
    let mask0 = (vec4<u32>(m, m >> 1u, m >> 2u, m >> 3u) % 2u) * 0xFFFFu;
    let mask1 = (vec4<u32>(m >> 4u, m >> 5u, m >> 6u, m >> 7u) % 2u) * 0xFFFFu;
    let mask2 = (vec4<u32>(m >> 8u, m >> 9u, m >> 10u, m >> 11u) % 2u) * 0xFFFFu;
    let mask3 = (vec4<u32>(m >> 12u, m >> 13u, m >> 14u, m >> 15u) % 2u) * 0xFFFFu;
    (*res).limbs[0] = (s0 + mask0) % 0x10000u;
    (*res).limbs[1] = (s1 + mask1) % 0x10000u;
    (*res).limbs[2] = (s2 + mask2) % 0x10000u;
    (*res).limbs[3] = (s3 + mask3) % 0x10000u;
    return c >> 16u;
}

fn vec_fr_add(
    a: ptr<function, VecBigInt256>,
    b: ptr<function, VecBigInt256>) -> VecBigInt256 {
    var res: VecBigInt256;
    vec_bigint_add(a, b, &res);
    return vec_fr_reduce(&res);
}

fn vec_fr_reduce(a: ptr<function, VecBigInt256>) -> VecBigInt256 {
    var res: VecBigInt256;
    var p: VecBigInt256;
    p.limbs[0] = p0;
    p.limbs[1] = p1;
    p.limbs[2] = p2;
    p.limbs[3] = p3;

    if (vec_bigint_sub(a, &p, &res) == 1u) {
        return *a;
    }
    else {
        return res;
    }
}

fn vec_cios_mon_pro_inner(t: ptr<function, array<vec4<u32>, 5>>) {
    var res: VecBigInt256;
    var high: VecBigInt256;
    var low: VecBigInt256;

    high.limbs[0] = vec4<u32>(0, (*t)[0].xyz) / 0x10000u;
    high.limbs[1] = vec4<u32>((*t)[0].w, (*t)[1].xyz) / 0x10000u;
    high.limbs[2] = vec4<u32>((*t)[1].w, (*t)[2].xyz) / 0x10000u;
    high.limbs[3] = vec4<u32>((*t)[2].w, (*t)[3].xyz) / 0x10000u;
    low.limbs[0] = (*t)[0] % 0x10000u;
    low.limbs[1] = (*t)[1] % 0x10000u;
    low.limbs[2] = (*t)[2] % 0x10000u;
    low.limbs[3] = (*t)[3] % 0x10000u;
    var r = (*t)[4].x + ((*t)[3].w >> 16u) + vec_bigint_add(&low, &high, &res);
    (*t)[0] = res.limbs[0];
    (*t)[1] = res.limbs[1];
    (*t)[2] = res.limbs[2];
    (*t)[3] = res.limbs[3];
    (*t)[4] = vec4<u32>(r & 0xFFFFu, r >> 16u, 0, 0);
    var m = ((*t)[0].x * 0xFFFFu) & 0xFFFFu;
    let tmp0 = (*t)[0] + m * p0;
    let tmp1 = (*t)[1] + m * p1;
    let tmp2 = (*t)[2] + m * p2;
    let tmp3 = (*t)[3] + m * p3;
    high.limbs[0] = vec4<u32>(0, tmp0.xyz) / 0x10000u;
    high.limbs[1] = vec4<u32>(tmp0.w, tmp1.xyz) / 0x10000u;
    high.limbs[2] = vec4<u32>(tmp1.w, tmp2.xyz) / 0x10000u;
    high.limbs[3] = vec4<u32>(tmp2.w, tmp3.xyz) / 0x10000u;
    low.limbs[0] = tmp0 % 0x10000u;
    low.limbs[1] = tmp1 % 0x10000u;
    low.limbs[2] = tmp2 % 0x10000u;
    low.limbs[3] = tmp3 % 0x10000u;
    r = (*t)[4].x + (tmp3.w >> 16u) + vec_bigint_add(&low, &high, &res);
    (*t)[0] = vec4<u32>(res.limbs[0].yzw, res.limbs[1].x);
    (*t)[1] = vec4<u32>(res.limbs[1].yzw, res.limbs[2].x);
    (*t)[2] = vec4<u32>(res.limbs[2].yzw, res.limbs[3].x);
    (*t)[3] = vec4<u32>(res.limbs[3].yzw, r & 0xFFFFu);
    (*t)[4].x = (*t)[4].y + (r >> 16u);
}

fn vec_cios_mon_pro(
    a: ptr<function, VecBigInt256>,
    b: ptr<function, VecBigInt256>) -> VecBigInt256 {
    var t: array<vec4<u32>, 5>;
    var res: VecBigInt256;
    var low: VecBigInt256;
    var p: VecBigInt256;
    p.limbs[0] = p0;
    p.limbs[1] = p1;
    p.limbs[2] = p2;
    p.limbs[3] = p3;

    var b_scalars: array<u32, 16> = array<u32, 16>(
        (*b).limbs[0].x, (*b).limbs[0].y, (*b).limbs[0].z, (*b).limbs[0].w,
        (*b).limbs[1].x, (*b).limbs[1].y, (*b).limbs[1].z, (*b).limbs[1].w,
        (*b).limbs[2].x, (*b).limbs[2].y, (*b).limbs[2].z, (*b).limbs[2].w,
        (*b).limbs[3].x, (*b).limbs[3].y, (*b).limbs[3].z, (*b).limbs[3].w
    );

    for (var i = 0u; i < 16u; i ++) {
        t[0] += (*a).limbs[0] * b_scalars[i];
        t[1] += (*a).limbs[1] * b_scalars[i];
        t[2] += (*a).limbs[2] * b_scalars[i];
        t[3] += (*a).limbs[3] * b_scalars[i];
        vec_cios_mon_pro_inner(&t);
    }

    low.limbs[0] = t[0];
    low.limbs[1] = t[1];
    low.limbs[2] = t[2];
    low.limbs[3] = t[3];

    if (t[4].x != 0u) || (vec_bigint_sub(&low, &p, &res) != 0u) {
        return low;
    } else {
        return res;
    }
}

@group(0)
@binding(0)
var<storage, read_write> buf: array<VecBigInt256>;

@group(0)
@binding(1)
var<storage, read> constants: array<VecBigInt256>;

@compute
@workgroup_size(64)
fn main(@builtin(global_invocation_id) global_id: vec3<u32>) {
    var a: VecBigInt256 = buf[global_id.x];
    var state_0: VecBigInt256;
    var state_1 = a;

    /*var n_rounds_f = 8u;*/
    /*var n_rounds_p = 56u;*/

    var m_0_0 = constants[global_id.y + 128u];
    var m_0_1 = constants[global_id.y + 129u];
    var m_1_0 = constants[global_id.y + 130u];
    var m_1_1 = constants[global_id.y + 131u];

    // for t == 2, n_rounds_f + n_rounds_p = 64
    for (var i = 0u; i < 64u; i ++) {
        // Add round constants (also known as "arc" or "ark")
        var c_0 = constants[global_id.y + i * 2u];
        var c_1 = constants[global_id.y + i * 2u + 1u];
        state_0 = vec_fr_add(&state_0, &c_0);
        state_1 = vec_fr_add(&state_1, &c_1);

        // S-Box
        var s0 = state_0;
        state_0 = vec_cios_mon_pro(&state_0, &state_0);
        state_0 = vec_cios_mon_pro(&state_0, &state_0);
        state_0 = vec_cios_mon_pro(&s0, &state_0);

        if (i < 4u || i >= 60u) {
            var s1 = state_1;
            state_1 = vec_cios_mon_pro(&state_1, &state_1);
            state_1 = vec_cios_mon_pro(&state_1, &state_1);
            state_1 = vec_cios_mon_pro(&s1, &state_1);
        }

        // Mix
        var m00s0 = vec_cios_mon_pro(&m_0_0, &state_0);
        var m01s1 = vec_cios_mon_pro(&m_0_1, &state_1);
        var m10s0 = vec_cios_mon_pro(&m_1_0, &state_0);
        var m11s1 = vec_cios_mon_pro(&m_1_1, &state_1);

        var new_state_0: VecBigInt256 = vec_fr_add(&m00s0, &m01s1);
        var new_state_1: VecBigInt256 = vec_fr_add(&m10s0, &m11s1);

        state_0 = new_state_0;
        state_1 = new_state_1;
    }

    buf[global_id.x] = state_0;
}
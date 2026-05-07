	.arch armv8-a
	.file	"main.cc"
	.text
	.section	.text._ZNKSt5ctypeIcE8do_widenEc,"axG",@progbits,_ZNKSt5ctypeIcE8do_widenEc,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNKSt5ctypeIcE8do_widenEc
	.type	_ZNKSt5ctypeIcE8do_widenEc, %function
_ZNKSt5ctypeIcE8do_widenEc:
.LFB1646:
	.cfi_startproc
	mov	w0, w1
	ret
	.cfi_endproc
.LFE1646:
	.size	_ZNKSt5ctypeIcE8do_widenEc, .-_ZNKSt5ctypeIcE8do_widenEc
	.section	.text._ZN7hnswlib17BaseFilterFunctorclEm,"axG",@progbits,_ZN7hnswlib17BaseFilterFunctorclEm,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib17BaseFilterFunctorclEm
	.type	_ZN7hnswlib17BaseFilterFunctorclEm, %function
_ZN7hnswlib17BaseFilterFunctorclEm:
.LFB3359:
	.cfi_startproc
	mov	w0, 1
	ret
	.cfi_endproc
.LFE3359:
	.size	_ZN7hnswlib17BaseFilterFunctorclEm, .-_ZN7hnswlib17BaseFilterFunctorclEm
	.text
	.align	2
	.p2align 4,,11
	.type	_ZN7hnswlibL20InnerProductDistanceEPKvS1_S1_, %function
_ZN7hnswlibL20InnerProductDistanceEPKvS1_S1_:
.LFB3401:
	.cfi_startproc
	ldr	x4, [x2]
	cbz	x4, .L7
	movi	v1.2s, #0
	mov	x2, 0
	mov	w3, 0
	.p2align 3,,7
.L6:
	ldr	s2, [x0, x2, lsl 2]
	add	w3, w3, 1
	ldr	s0, [x1, x2, lsl 2]
	uxtw	x2, w3
	fmadd	s1, s2, s0, s1
	cmp	x4, x2
	bhi	.L6
	fmov	s0, 1.0e+0
	fsub	s0, s0, s1
	ret
	.p2align 2,,3
.L7:
	fmov	s0, 1.0e+0
	ret
	.cfi_endproc
.LFE3401:
	.size	_ZN7hnswlibL20InnerProductDistanceEPKvS1_S1_, .-_ZN7hnswlibL20InnerProductDistanceEPKvS1_S1_
	.section	.text._ZN7hnswlib17InnerProductSpace13get_data_sizeEv,"axG",@progbits,_ZN7hnswlib17InnerProductSpace13get_data_sizeEv,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib17InnerProductSpace13get_data_sizeEv
	.type	_ZN7hnswlib17InnerProductSpace13get_data_sizeEv, %function
_ZN7hnswlib17InnerProductSpace13get_data_sizeEv:
.LFB3405:
	.cfi_startproc
	ldr	x0, [x0, 16]
	ret
	.cfi_endproc
.LFE3405:
	.size	_ZN7hnswlib17InnerProductSpace13get_data_sizeEv, .-_ZN7hnswlib17InnerProductSpace13get_data_sizeEv
	.section	.text._ZN7hnswlib17InnerProductSpace13get_dist_funcEv,"axG",@progbits,_ZN7hnswlib17InnerProductSpace13get_dist_funcEv,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib17InnerProductSpace13get_dist_funcEv
	.type	_ZN7hnswlib17InnerProductSpace13get_dist_funcEv, %function
_ZN7hnswlib17InnerProductSpace13get_dist_funcEv:
.LFB3406:
	.cfi_startproc
	ldr	x0, [x0, 8]
	ret
	.cfi_endproc
.LFE3406:
	.size	_ZN7hnswlib17InnerProductSpace13get_dist_funcEv, .-_ZN7hnswlib17InnerProductSpace13get_dist_funcEv
	.section	.text._ZN7hnswlib17InnerProductSpace19get_dist_func_paramEv,"axG",@progbits,_ZN7hnswlib17InnerProductSpace19get_dist_func_paramEv,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib17InnerProductSpace19get_dist_func_paramEv
	.type	_ZN7hnswlib17InnerProductSpace19get_dist_func_paramEv, %function
_ZN7hnswlib17InnerProductSpace19get_dist_func_paramEv:
.LFB3407:
	.cfi_startproc
	add	x0, x0, 24
	ret
	.cfi_endproc
.LFE3407:
	.size	_ZN7hnswlib17InnerProductSpace19get_dist_func_paramEv, .-_ZN7hnswlib17InnerProductSpace19get_dist_func_paramEv
	.section	.text._ZN7hnswlib17InnerProductSpaceD2Ev,"axG",@progbits,_ZN7hnswlib17InnerProductSpaceD5Ev,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib17InnerProductSpaceD2Ev
	.type	_ZN7hnswlib17InnerProductSpaceD2Ev, %function
_ZN7hnswlib17InnerProductSpaceD2Ev:
.LFB3409:
	.cfi_startproc
	ret
	.cfi_endproc
.LFE3409:
	.size	_ZN7hnswlib17InnerProductSpaceD2Ev, .-_ZN7hnswlib17InnerProductSpaceD2Ev
	.weak	_ZN7hnswlib17InnerProductSpaceD1Ev
	.set	_ZN7hnswlib17InnerProductSpaceD1Ev,_ZN7hnswlib17InnerProductSpaceD2Ev
	.section	.text._ZN3annL26inner_product_scalar_novecEPKfS1_m,"axG",@progbits,_ZN3ann11ip_distanceEPKfS1_mNS_12SearchMethodE,comdat
	.align	2
	.p2align 4,,11
	.type	_ZN3annL26inner_product_scalar_novecEPKfS1_m, %function
_ZN3annL26inner_product_scalar_novecEPKfS1_m:
.LFB10372:
	.cfi_startproc
	movi	v0.2s, #0
	cbz	x2, .L13
	mov	x3, 0
	.p2align 3,,7
.L15:
	ldr	s2, [x0, x3, lsl 2]
	ldr	s1, [x1, x3, lsl 2]
	add	x3, x3, 1
	fmadd	s0, s2, s1, s0
	cmp	x2, x3
	bne	.L15
.L13:
	ret
	.cfi_endproc
.LFE10372:
	.size	_ZN3annL26inner_product_scalar_novecEPKfS1_m, .-_ZN3annL26inner_product_scalar_novecEPKfS1_m
	.section	.text._ZN7hnswlib17InnerProductSpaceD0Ev,"axG",@progbits,_ZN7hnswlib17InnerProductSpaceD5Ev,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib17InnerProductSpaceD0Ev
	.type	_ZN7hnswlib17InnerProductSpaceD0Ev, %function
_ZN7hnswlib17InnerProductSpaceD0Ev:
.LFB3411:
	.cfi_startproc
	b	_ZdlPv
	.cfi_endproc
.LFE3411:
	.size	_ZN7hnswlib17InnerProductSpaceD0Ev, .-_ZN7hnswlib17InnerProductSpaceD0Ev
	.section	.text._ZN3ann15build_sq8_indexEPKfmmRNS_8SQ8IndexE._omp_fn.0,"axG",@progbits,_ZN3ann15build_sq8_indexEPKfmmRNS_8SQ8IndexE,comdat
	.align	2
	.p2align 4,,11
	.type	_ZN3ann15build_sq8_indexEPKfmmRNS_8SQ8IndexE._omp_fn.0, %function
_ZN3ann15build_sq8_indexEPKfmmRNS_8SQ8IndexE._omp_fn.0:
.LFB13024:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -32
	.cfi_offset 20, -24
	mov	x19, x0
	str	x21, [sp, 32]
	.cfi_offset 21, -16
	bl	omp_get_num_threads
	sxtw	x20, w0
	bl	omp_get_thread_num
	ldr	x21, [x19, 8]
	sxtw	x10, w0
	sdiv	x12, x21, x20
	msub	x0, x12, x20, x21
	cmp	x10, x0
	blt	.L20
.L26:
	madd	x10, x12, x10, x0
	add	x12, x12, x10
	cmp	x10, x12
	bge	.L19
	ldp	x6, x13, [x19, 16]
	fmov	s3, 5.0e-1
	ldr	x5, [x19]
	mov	w9, 255
	lsl	x14, x6, 2
	mul	x11, x6, x10
	add	x15, x13, 16
	madd	x5, x14, x10, x5
	.p2align 3,,7
.L23:
	ldr	x4, [x15]
	cbz	x6, .L25
	add	x4, x4, x11
	add	x8, x13, 40
	add	x7, x13, 64
	mov	x0, 0
	.p2align 3,,7
.L22:
	ldr	x3, [x8]
	mov	w2, 0
	ldr	x1, [x7]
	ldr	s2, [x3, x0, lsl 2]
	ldr	s0, [x5, x0, lsl 2]
	ldr	s1, [x1, x0, lsl 2]
	fsub	s0, s0, s2
	fdiv	s0, s0, s1
	fadd	s0, s0, s3
	fcvtms	w1, s0
	and	w3, w1, 255
	tbnz	w1, #31, .L24
	cmp	w1, 256
	csel	w2, w3, w9, lt
.L24:
	strb	w2, [x4, x0]
	add	x0, x0, 1
	cmp	x6, x0
	bne	.L22
.L25:
	add	x10, x10, 1
	add	x11, x11, x6
	add	x5, x5, x14
	cmp	x12, x10
	bne	.L23
.L19:
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
.L20:
	.cfi_restore_state
	add	x12, x12, 1
	mov	x0, 0
	b	.L26
	.cfi_endproc
.LFE13024:
	.size	_ZN3ann15build_sq8_indexEPKfmmRNS_8SQ8IndexE._omp_fn.0, .-_ZN3ann15build_sq8_indexEPKfmmRNS_8SQ8IndexE._omp_fn.0
	.section	.text._ZN3ann14build_pq_indexEPKfmmiiiiRNS_7PQIndexE._omp_fn.0,"axG",@progbits,_ZN3ann14build_pq_indexEPKfmmiiiiRNS_7PQIndexE,comdat
	.align	2
	.p2align 4,,11
	.type	_ZN3ann14build_pq_indexEPKfmmiiiiRNS_7PQIndexE._omp_fn.0, %function
_ZN3ann14build_pq_indexEPKfmmiiiiRNS_7PQIndexE._omp_fn.0:
.LFB13025:
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x3, 128
	mov	x2, 1
	mov	x29, sp
	ldr	x1, [x0, 8]
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	mov	x23, x0
	add	x5, sp, 88
	add	x4, sp, 80
	ldr	x1, [x1]
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	ldp	w21, w20, [x0, 32]
	mov	x0, 0
	ldr	x22, [x23]
	ldr	x19, [x23, 16]
	bl	GOMP_loop_nonmonotonic_dynamic_start
	tst	w0, 255
	beq	.L33
	sxtw	x24, w21
	mov	w0, 2139095039
	str	d8, [sp, 64]
	.cfi_offset 72, -32
	fmov	s8, w0
.L36:
	ldp	x13, x14, [sp, 80]
	ldr	x8, [x23, 24]
	mul	x10, x13, x24
	mul	x9, x19, x13
.L35:
	add	x12, x8, 40
	add	x11, x8, 64
	mov	x7, 0
	cmp	w21, 0
	ble	.L38
	.p2align 3,,7
.L34:
	ldr	w2, [x8, 24]
	ldr	x4, [x12]
	sxtw	x5, w2
	smull	x0, w2, w20
	madd	x1, x5, x7, x9
	mul	x0, x0, x7
	lsl	x3, x1, 2
	cmp	w20, 0
	ble	.L57
	fmov	s3, s8
	lsl	x5, x5, 2
	add	x3, x22, x3
	add	x1, x4, x0, lsl 2
	mov	w6, 0
	mov	w4, 0
	.p2align 3,,7
.L43:
	movi	v1.2s, #0
	cmp	w2, 0
	ble	.L39
	mov	x0, 0
	.p2align 3,,7
.L40:
	ldr	s0, [x3, x0, lsl 2]
	ldr	s2, [x1, x0, lsl 2]
	add	x0, x0, 1
	fsub	s0, s0, s2
	fmadd	s1, s0, s0, s1
	cmp	w2, w0
	bgt	.L40
.L39:
	fcmpe	s3, s1
	bgt	.L47
.L41:
	add	w4, w4, 1
	add	x1, x1, x5
	cmp	w20, w4
	bne	.L43
	and	w6, w6, 255
.L44:
	ldr	x0, [x11]
	add	x0, x0, x10
	strb	w6, [x0, x7]
	add	x7, x7, 1
	cmp	w21, w7
	bgt	.L34
.L38:
	add	x13, x13, 1
	add	x10, x10, x24
	add	x9, x9, x19
	cmp	x14, x13
	bgt	.L35
	add	x1, sp, 88
	add	x0, sp, 80
	bl	GOMP_loop_nonmonotonic_dynamic_next
	tst	w0, 255
	bne	.L36
	ldr	d8, [sp, 64]
	.cfi_restore 72
.L33:
	bl	GOMP_loop_end_nowait
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 96
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L47:
	.cfi_def_cfa_offset 96
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	.cfi_offset 72, -32
	fmov	s3, s1
	mov	w6, w4
	b	.L41
.L57:
	mov	w6, 0
	b	.L44
	.cfi_endproc
.LFE13025:
	.size	_ZN3ann14build_pq_indexEPKfmmiiiiRNS_7PQIndexE._omp_fn.0, .-_ZN3ann14build_pq_indexEPKfmmiiiiRNS_7PQIndexE._omp_fn.0
	.text
	.align	2
	.p2align 4,,11
	.type	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfmESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0, %function
_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfmESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0:
.LFB13104:
	.cfi_startproc
	sub	x4, x1, #1
	add	x4, x4, x4, lsr 63
	asr	x4, x4, 1
	cmp	x1, x2
	ble	.L70
.L59:
	lsl	x5, x4, 4
	add	x6, x0, x5
	ldr	s1, [x0, x5]
	fcmpe	s1, s0
	bmi	.L61
	bgt	.L70
	ldr	x8, [x6, 8]
	cmp	x8, x3
	bcc	.L64
.L70:
	add	x6, x0, x1, lsl 4
.L60:
	str	s0, [x6]
	str	x3, [x6, 8]
	ret
	.p2align 2,,3
.L61:
	ldr	x8, [x6, 8]
.L64:
	lsl	x7, x1, 4
	sub	x5, x4, #1
	add	x9, x0, x7
	mov	x1, x4
	add	x5, x5, x5, lsr 63
	str	s1, [x0, x7]
	str	x8, [x9, 8]
	asr	x4, x5, 1
	cmp	x1, x2
	bgt	.L59
	b	.L60
	.cfi_endproc
.LFE13104:
	.size	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfmESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0, .-_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfmESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	.align	2
	.p2align 4,,11
	.type	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0, %function
_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0:
.LFB13064:
	.cfi_startproc
	sub	x4, x1, #1
	lsr	x9, x3, 32
	mov	w10, w9
	lsr	w3, w3, 0
	add	x4, x4, x4, lsr 63
	fmov	d0, x3
	asr	x4, x4, 1
	cmp	x1, x2
	ble	.L83
.L72:
	lsl	x3, x4, 3
	add	x5, x0, x3
	ldr	s1, [x0, x3]
	fcmpe	s0, s1
	bgt	.L74
	bmi	.L83
	ldr	w7, [x5, 4]
	cmp	w10, w7
	bhi	.L77
.L83:
	add	x5, x0, x1, lsl 3
.L73:
	str	s0, [x5]
	str	w9, [x5, 4]
	ret
	.p2align 2,,3
.L74:
	ldr	w7, [x5, 4]
.L77:
	lsl	x6, x1, 3
	sub	x3, x4, #1
	add	x8, x0, x6
	mov	x1, x4
	add	x3, x3, x3, lsr 63
	str	s1, [x0, x6]
	str	w7, [x8, 4]
	asr	x4, x3, 1
	cmp	x2, x1
	blt	.L72
	b	.L73
	.cfi_endproc
.LFE13064:
	.size	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0, .-_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	.align	2
	.p2align 4,,11
	.type	_ZNSt8_Rb_treeIjjSt9_IdentityIjESt4lessIjESaIjEE8_M_eraseEPSt13_Rb_tree_nodeIjE.isra.0, %function
_ZNSt8_Rb_treeIjjSt9_IdentityIjESt4lessIjESaIjEE8_M_eraseEPSt13_Rb_tree_nodeIjE.isra.0:
.LFB13060:
	.cfi_startproc
	cbz	x0, .L145
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	mov	x23, x0
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
.L102:
	ldr	x24, [x23, 24]
	cbz	x24, .L86
	stp	x25, x26, [sp, 64]
	.cfi_offset 26, -24
	.cfi_offset 25, -32
.L101:
	ldr	x25, [x24, 24]
	cbz	x25, .L87
.L100:
	ldr	x26, [x25, 24]
	cbz	x26, .L88
.L99:
	ldr	x19, [x26, 24]
	cbz	x19, .L89
.L98:
	ldr	x20, [x19, 24]
	cbz	x20, .L90
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -56
	.cfi_offset 21, -64
	str	x27, [sp, 80]
	.cfi_offset 27, -16
.L97:
	ldr	x27, [x20, 24]
	cbz	x27, .L91
.L96:
	ldr	x21, [x27, 24]
	cbz	x21, .L92
.L95:
	ldr	x22, [x21, 24]
	cbz	x22, .L93
.L94:
	ldr	x0, [x22, 24]
	bl	_ZNSt8_Rb_treeIjjSt9_IdentityIjESt4lessIjESaIjEE8_M_eraseEPSt13_Rb_tree_nodeIjE.isra.0
	mov	x0, x22
	ldr	x22, [x22, 16]
	bl	_ZdlPv
	cbnz	x22, .L94
.L93:
	ldr	x22, [x21, 16]
	mov	x0, x21
	bl	_ZdlPv
	cbz	x22, .L92
	mov	x21, x22
	b	.L95
.L146:
	ldp	x21, x22, [sp, 32]
	.cfi_restore 22
	.cfi_restore 21
	ldr	x27, [sp, 80]
	.cfi_restore 27
.L90:
	mov	x0, x19
	ldr	x20, [x19, 16]
	bl	_ZdlPv
	cbz	x20, .L89
	mov	x19, x20
	b	.L98
	.p2align 2,,3
.L91:
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.cfi_offset 27, -16
	ldr	x21, [x20, 16]
	mov	x0, x20
	bl	_ZdlPv
	cbz	x21, .L146
	mov	x20, x21
	b	.L97
.L89:
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 27
	ldr	x19, [x26, 16]
	mov	x0, x26
	bl	_ZdlPv
	cbz	x19, .L88
	mov	x26, x19
	b	.L99
	.p2align 2,,3
.L92:
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.cfi_offset 27, -16
	ldr	x21, [x27, 16]
	mov	x0, x27
	bl	_ZdlPv
	cbz	x21, .L91
	mov	x27, x21
	b	.L96
.L88:
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 27
	ldr	x19, [x25, 16]
	mov	x0, x25
	bl	_ZdlPv
	cbz	x19, .L87
	mov	x25, x19
	b	.L100
.L87:
	ldr	x19, [x24, 16]
	mov	x0, x24
	bl	_ZdlPv
	cbz	x19, .L147
	mov	x24, x19
	b	.L101
.L147:
	ldp	x25, x26, [sp, 64]
	.cfi_restore 26
	.cfi_restore 25
.L86:
	mov	x0, x23
	ldr	x19, [x23, 16]
	bl	_ZdlPv
	cbz	x19, .L148
	mov	x23, x19
	b	.L102
.L148:
	ldp	x19, x20, [sp, 16]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 96
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
.L145:
	ret
	.cfi_endproc
.LFE13060:
	.size	_ZNSt8_Rb_treeIjjSt9_IdentityIjESt4lessIjESaIjEE8_M_eraseEPSt13_Rb_tree_nodeIjE.isra.0, .-_ZNSt8_Rb_treeIjjSt9_IdentityIjESt4lessIjESaIjEE8_M_eraseEPSt13_Rb_tree_nodeIjE.isra.0
	.section	.text._ZN3ann18inner_product_autoEPKfS1_m,"axG",@progbits,_ZN3ann18inner_product_autoEPKfS1_m,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN3ann18inner_product_autoEPKfS1_m
	.type	_ZN3ann18inner_product_autoEPKfS1_m, %function
_ZN3ann18inner_product_autoEPKfS1_m:
.LFB10373:
	.cfi_startproc
	cmp	x2, 3
	bls	.L154
	movi	v1.2s, #0
	sub	x5, x2, #4
	add	x7, x0, 16
	mov	x3, x0
	lsr	x6, x5, 2
	mov	x4, x1
	fmov	s2, s1
	fmov	s3, s1
	fmov	s0, s1
	add	x6, x7, x6, lsl 4
	.p2align 3,,7
.L151:
	ldp	s5, s17, [x3]
	add	x3, x3, 16
	ldp	s4, s16, [x4]
	add	x4, x4, 16
	ldr	s7, [x3, -8]
	ldr	s6, [x4, -8]
	fmadd	s0, s5, s4, s0
	ldr	s5, [x3, -4]
	ldr	s4, [x4, -4]
	fmadd	s3, s17, s16, s3
	fmadd	s2, s7, s6, s2
	fmadd	s1, s5, s4, s1
	cmp	x6, x3
	bne	.L151
	fadd	s0, s0, s3
	and	x3, x5, -4
	fadd	s2, s2, s1
	add	x3, x3, 4
	fadd	s0, s0, s2
.L150:
	cmp	x2, x3
	bls	.L149
	.p2align 3,,7
.L153:
	ldr	s2, [x0, x3, lsl 2]
	ldr	s1, [x1, x3, lsl 2]
	add	x3, x3, 1
	fmadd	s0, s2, s1, s0
	cmp	x2, x3
	bne	.L153
.L149:
	ret
	.p2align 2,,3
.L154:
	movi	v0.2s, #0
	mov	x3, 0
	b	.L150
	.cfi_endproc
.LFE10373:
	.size	_ZN3ann18inner_product_autoEPKfS1_m, .-_ZN3ann18inner_product_autoEPKfS1_m
	.section	.text._ZN3ann18inner_product_neonEPKfS1_m,"axG",@progbits,_ZN3ann18inner_product_neonEPKfS1_m,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN3ann18inner_product_neonEPKfS1_m
	.type	_ZN3ann18inner_product_neonEPKfS1_m, %function
_ZN3ann18inner_product_neonEPKfS1_m:
.LFB10376:
	.cfi_startproc
	movi	v0.4s, 0
	cmp	x2, 3
	bls	.L162
	mov	x6, x0
	mov	x5, x1
	mov	x4, 4
	.p2align 3,,7
.L159:
	ldr	q1, [x6], 16
	mov	x3, x4
	ldr	q2, [x5], 16
	add	x4, x4, 4
	fmla	v0.4s, v2.4s, v1.4s
	cmp	x2, x4
	bcs	.L159
.L158:
	faddp	v0.4s, v0.4s, v0.4s
	faddp	v0.4s, v0.4s, v0.4s
	cmp	x2, x3
	bls	.L157
	.p2align 3,,7
.L161:
	ldr	s2, [x0, x3, lsl 2]
	ldr	s1, [x1, x3, lsl 2]
	add	x3, x3, 1
	fmadd	s0, s2, s1, s0
	cmp	x2, x3
	bne	.L161
.L157:
	ret
	.p2align 2,,3
.L162:
	mov	x3, 0
	b	.L158
	.cfi_endproc
.LFE10376:
	.size	_ZN3ann18inner_product_neonEPKfS1_m, .-_ZN3ann18inner_product_neonEPKfS1_m
	.section	.text._ZN3ann11ip_distanceEPKfS1_mNS_12SearchMethodE,"axG",@progbits,_ZN3ann11ip_distanceEPKfS1_mNS_12SearchMethodE,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN3ann11ip_distanceEPKfS1_mNS_12SearchMethodE
	.type	_ZN3ann11ip_distanceEPKfS1_mNS_12SearchMethodE, %function
_ZN3ann11ip_distanceEPKfS1_mNS_12SearchMethodE:
.LFB10380:
	.cfi_startproc
	stp	x29, x30, [sp, -16]!
	.cfi_def_cfa_offset 16
	.cfi_offset 29, -16
	.cfi_offset 30, -8
	mov	x5, x0
	mov	x6, x1
	mov	x29, sp
	cmp	w3, 3
	beq	.L175
	mov	x4, x2
	bhi	.L167
	cbz	w3, .L168
	cmp	w3, 2
	bne	.L170
.L175:
	bl	_ZN3ann18inner_product_neonEPKfS1_m
	fmov	s1, 1.0e+0
	ldp	x29, x30, [sp], 16
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	fsub	s0, s1, s0
	ret
	.p2align 2,,3
.L167:
	.cfi_restore_state
	cmp	w3, 4
	beq	.L171
	sub	w3, w3, #5
	cmp	w3, 2
	bls	.L192
.L170:
	mov	x2, x4
	mov	x1, x6
	mov	x0, x5
	bl	_ZN3ann18inner_product_autoEPKfS1_m
	fmov	s1, 1.0e+0
	ldp	x29, x30, [sp], 16
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	fsub	s0, s1, s0
	ret
	.p2align 2,,3
.L192:
	.cfi_restore_state
	cmp	x2, 15
	bls	.L193
	movi	v2.4s, 0
	mov	x1, x0
	mov	x0, x6
	mov	x3, 16
	mov	v3.16b, v2.16b
	mov	v1.16b, v2.16b
	mov	v0.16b, v2.16b
	.p2align 3,,7
.L181:
	ldp	q18, q16, [x0]
	mov	x2, x3
	ldp	q19, q17, [x1]
	add	x3, x3, 16
	ldp	q6, q4, [x0, 32]
	add	x0, x0, 64
	ldp	q7, q5, [x1, 32]
	add	x1, x1, 64
	fmla	v0.4s, v19.4s, v18.4s
	fmla	v1.4s, v17.4s, v16.4s
	fmla	v3.4s, v7.4s, v6.4s
	fmla	v2.4s, v5.4s, v4.4s
	cmp	x4, x3
	bcs	.L181
	fadd	v1.4s, v0.4s, v1.4s
	fadd	v3.4s, v3.4s, v2.4s
	fadd	v1.4s, v1.4s, v3.4s
.L172:
	faddp	v1.4s, v1.4s, v1.4s
	faddp	v1.4s, v1.4s, v1.4s
	cmp	x4, x2
	bls	.L182
	.p2align 3,,7
.L183:
	ldr	s2, [x5, x2, lsl 2]
	ldr	s0, [x6, x2, lsl 2]
	add	x2, x2, 1
	fmadd	s1, s2, s0, s1
	cmp	x4, x2
	bne	.L183
.L182:
	fmov	s0, 1.0e+0
	ldp	x29, x30, [sp], 16
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	fsub	s0, s0, s1
	ret
	.p2align 2,,3
.L168:
	.cfi_restore_state
	bl	_ZN3annL26inner_product_scalar_novecEPKfS1_m
	fmov	s1, 1.0e+0
	ldp	x29, x30, [sp], 16
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	fsub	s0, s1, s0
	ret
	.p2align 2,,3
.L171:
	.cfi_restore_state
	cmp	x2, 7
	bls	.L185
	movi	v0.4s, 0
	add	x1, x1, 16
	add	x3, x0, 16
	mov	x0, 8
	mov	v1.16b, v0.16b
	.p2align 3,,7
.L178:
	ldr	q4, [x1, -16]
	mov	x2, x0
	ldr	q5, [x3, -16]
	add	x0, x0, 8
	ldr	q2, [x1], 32
	ldr	q3, [x3], 32
	fmla	v1.4s, v5.4s, v4.4s
	fmla	v0.4s, v3.4s, v2.4s
	cmp	x4, x0
	bcs	.L178
	fadd	v1.4s, v1.4s, v0.4s
.L177:
	faddp	v1.4s, v1.4s, v1.4s
	faddp	v1.4s, v1.4s, v1.4s
	cmp	x4, x2
	bls	.L182
	.p2align 3,,7
.L180:
	ldr	s2, [x5, x2, lsl 2]
	ldr	s0, [x6, x2, lsl 2]
	add	x2, x2, 1
	fmadd	s1, s2, s0, s1
	cmp	x4, x2
	bne	.L180
	b	.L182
	.p2align 2,,3
.L193:
	movi	v1.4s, 0
	mov	x2, 0
	b	.L172
	.p2align 2,,3
.L185:
	movi	v1.4s, 0
	mov	x2, 0
	b	.L177
	.cfi_endproc
.LFE10380:
	.size	_ZN3ann11ip_distanceEPKfS1_mNS_12SearchMethodE, .-_ZN3ann11ip_distanceEPKfS1_mNS_12SearchMethodE
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align	3
.LC5:
	.string	"files"
	.align	3
.LC6:
	.string	"HOME"
	.align	3
.LC7:
	.string	"basic_string::append"
	.align	3
.LC8:
	.string	"/files"
	.text
	.align	2
	.p2align 4,,11
	.global	_Z13get_files_dirB5cxx11v
	.type	_Z13get_files_dirB5cxx11v, %function
_Z13get_files_dirB5cxx11v:
.LFB10439:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA10439
	stp	x29, x30, [sp, -224]!
	.cfi_def_cfa_offset 224
	.cfi_offset 29, -224
	.cfi_offset 30, -216
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -208
	.cfi_offset 20, -200
	adrp	x20, .LC5
	add	x20, x20, :lo12:.LC5
	mov	x19, x8
	mov	x0, x20
	add	x1, sp, 96
	bl	stat
	cbnz	w0, .L195
	ldr	w0, [sp, 112]
	and	w0, w0, 61440
	cmp	w0, 16384
	beq	.L219
.L195:
	adrp	x0, .LC6
	add	x0, x0, :lo12:.LC6
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -184
	.cfi_offset 21, -192
	bl	getenv
	mov	x21, x0
	cbz	x0, .L197
	ldrb	w1, [x0]
	cbnz	w1, .L220
.L197:
	ldr	w2, [x20]
	add	x0, x19, 16
	str	w2, [x19, 16]
	mov	x1, 5
	ldrb	w2, [x20, 4]
	stp	x0, x1, [x19]
	mov	x0, x19
	strb	w2, [x19, 20]
	strb	wzr, [x19, 21]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	.cfi_remember_state
	.cfi_restore 22
	.cfi_restore 21
	ldp	x29, x30, [sp], 224
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L220:
	.cfi_restore_state
	add	x22, sp, 80
	str	x22, [sp, 64]
	bl	strlen
	str	x0, [sp, 56]
	mov	x20, x0
	cmp	x0, 15
	bhi	.L221
	cmp	x0, 1
	bne	.L200
	ldrb	w1, [x21]
	mov	x0, x22
	strb	w1, [sp, 80]
.L201:
	str	x20, [sp, 72]
	strb	wzr, [x0, x20]
	mov	x0, 4611686018427387903
	ldr	x1, [sp, 72]
	sub	x0, x0, x1
	cmp	x0, 5
	bls	.L222
	adrp	x1, .LC8
	add	x0, sp, 64
	add	x1, x1, :lo12:.LC8
	mov	x2, 6
.LEHB0:
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE9_M_appendEPKcm
.LEHE0:
	add	x2, x19, 16
	str	x2, [x19]
	mov	x1, x0
	ldr	x2, [x0], 16
	cmp	x2, x0
	beq	.L223
	ldr	x3, [x1, 16]
	str	x2, [x19]
	str	x3, [x19, 16]
.L204:
	str	x0, [x1]
	add	x2, sp, 80
	ldr	x0, [x1, 8]
	str	x0, [x19, 8]
	ldr	x0, [sp, 64]
	str	xzr, [x1, 8]
	strb	wzr, [x1, 16]
	cmp	x0, x2
	beq	.L218
	bl	_ZdlPv
	mov	x0, x19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	.cfi_remember_state
	.cfi_restore 22
	.cfi_restore 21
	ldp	x29, x30, [sp], 224
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L221:
	.cfi_restore_state
	add	x1, sp, 56
	add	x0, sp, 64
	mov	x2, 0
.LEHB1:
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE9_M_createERmm
.LEHE1:
	ldr	x1, [sp, 56]
	str	x0, [sp, 64]
	str	x1, [sp, 80]
.L199:
	mov	x2, x20
	mov	x1, x21
	bl	memcpy
	ldp	x20, x0, [sp, 56]
	b	.L201
	.p2align 2,,3
.L219:
	.cfi_restore 21
	.cfi_restore 22
	ldr	w2, [x20]
	add	x0, x19, 16
	str	w2, [x19, 16]
	mov	x1, 5
	ldrb	w2, [x20, 4]
	stp	x0, x1, [x19]
	mov	x0, x19
	strb	w2, [x19, 20]
	strb	wzr, [x19, 21]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 224
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L218:
	.cfi_def_cfa_offset 224
	.cfi_offset 19, -208
	.cfi_offset 20, -200
	.cfi_offset 21, -192
	.cfi_offset 22, -184
	.cfi_offset 29, -224
	.cfi_offset 30, -216
	mov	x0, x19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	.cfi_remember_state
	.cfi_restore 22
	.cfi_restore 21
	ldp	x29, x30, [sp], 224
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L200:
	.cfi_restore_state
	mov	x0, x22
	cbz	x20, .L201
	b	.L199
	.p2align 2,,3
.L223:
	ldp	x2, x3, [x1, 16]
	stp	x2, x3, [x19, 16]
	b	.L204
.L222:
	adrp	x0, .LC7
	add	x0, x0, :lo12:.LC7
.LEHB2:
	bl	_ZSt20__throw_length_errorPKc
.LEHE2:
.L209:
	ldr	x2, [sp, 64]
	add	x1, sp, 80
	mov	x19, x0
	cmp	x2, x1
	beq	.L207
	mov	x0, x2
	bl	_ZdlPv
.L207:
	mov	x0, x19
.LEHB3:
	bl	_Unwind_Resume
.LEHE3:
	.cfi_endproc
.LFE10439:
	.global	__gxx_personality_v0
	.section	.gcc_except_table,"a",@progbits
.LLSDA10439:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE10439-.LLSDACSB10439
.LLSDACSB10439:
	.uleb128 .LEHB0-.LFB10439
	.uleb128 .LEHE0-.LEHB0
	.uleb128 .L209-.LFB10439
	.uleb128 0
	.uleb128 .LEHB1-.LFB10439
	.uleb128 .LEHE1-.LEHB1
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB2-.LFB10439
	.uleb128 .LEHE2-.LEHB2
	.uleb128 .L209-.LFB10439
	.uleb128 0
	.uleb128 .LEHB3-.LFB10439
	.uleb128 .LEHE3-.LEHB3
	.uleb128 0
	.uleb128 0
.LLSDACSE10439:
	.text
	.size	_Z13get_files_dirB5cxx11v, .-_Z13get_files_dirB5cxx11v
	.section	.rodata.str1.8
	.align	3
.LC9:
	.string	"warning: failed to create dir "
	.align	3
.LC10:
	.string	"\n"
	.text
	.align	2
	.p2align 4,,11
	.global	_Z10ensure_dirRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
	.type	_Z10ensure_dirRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE, %function
_Z10ensure_dirRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE:
.LFB10440:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -16
	.cfi_offset 20, -8
	mov	x19, x0
	ldr	x0, [x0, 8]
	cbnz	x0, .L235
.L224:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L235:
	.cfi_restore_state
	ldr	x0, [x19]
	mov	w1, 493
	bl	mkdir
	cbz	w0, .L224
	bl	__errno_location
	ldr	w0, [x0]
	cmp	w0, 17
	beq	.L224
	adrp	x20, _ZSt4cerr
	add	x20, x20, :lo12:_ZSt4cerr
	mov	x0, x20
	mov	x2, 30
	adrp	x1, .LC9
	add	x1, x1, :lo12:.LC9
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	ldp	x1, x2, [x19]
	mov	x0, x20
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	ldp	x19, x20, [sp, 16]
	adrp	x1, .LC10
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	add	x1, x1, :lo12:.LC10
	mov	x2, 1
	b	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	.cfi_endproc
.LFE10440:
	.size	_Z10ensure_dirRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE, .-_Z10ensure_dirRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
	.align	2
	.p2align 4,,11
	.global	_Z6now_usv
	.type	_Z6now_usv, %function
_Z6now_usv:
.LFB10441:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x1, 0
	mov	x29, sp
	add	x0, sp, 16
	bl	gettimeofday
	ldp	x2, x1, [sp, 16]
	mov	x0, 16960
	movk	x0, 0xf, lsl 16
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_def_cfa_offset 0
	madd	x0, x2, x0, x1
	ret
	.cfi_endproc
.LFE10441:
	.size	_Z6now_usv, .-_Z6now_usv
	.align	2
	.p2align 4,,11
	.global	_Z13method_unrollN3ann12SearchMethodE
	.type	_Z13method_unrollN3ann12SearchMethodE, %function
_Z13method_unrollN3ann12SearchMethodE:
.LFB10459:
	.cfi_startproc
	cmp	w0, 4
	beq	.L240
	sub	w0, w0, #5
	mov	w1, 4
	cmp	w0, 2
	csinc	w0, w1, wzr, ls
	ret
	.p2align 2,,3
.L240:
	mov	w0, 2
	ret
	.cfi_endproc
.LFE10459:
	.size	_Z13method_unrollN3ann12SearchMethodE, .-_Z13method_unrollN3ann12SearchMethodE
	.align	2
	.p2align 4,,11
	.global	_Z15method_prefetchN3ann12SearchMethodE
	.type	_Z15method_prefetchN3ann12SearchMethodE, %function
_Z15method_prefetchN3ann12SearchMethodE:
.LFB10460:
	.cfi_startproc
	sub	w0, w0, #6
	cmp	w0, 2
	cset	w0, cc
	lsl	w0, w0, 4
	ret
	.cfi_endproc
.LFE10460:
	.size	_Z15method_prefetchN3ann12SearchMethodE, .-_Z15method_prefetchN3ann12SearchMethodE
	.section	.rodata.str1.8
	.align	3
.LC11:
	.string	"fixed-array"
	.align	3
.LC12:
	.string	"heap"
	.text
	.align	2
	.p2align 4,,11
	.global	_Z11method_topkN3ann12SearchMethodE
	.type	_Z11method_topkN3ann12SearchMethodE, %function
_Z11method_topkN3ann12SearchMethodE:
.LFB10461:
	.cfi_startproc
	cmp	w0, 7
	adrp	x1, .LC12
	adrp	x0, .LC11
	add	x1, x1, :lo12:.LC12
	add	x0, x0, :lo12:.LC11
	csel	x0, x0, x1, eq
	ret
	.cfi_endproc
.LFE10461:
	.size	_Z11method_topkN3ann12SearchMethodE, .-_Z11method_topkN3ann12SearchMethodE
	.section	.rodata.str1.8
	.align	3
.LC13:
	.string	","
	.text
	.align	2
	.p2align 4,,11
	.global	_Z16write_result_rowRSt14basic_ofstreamIcSt11char_traitsIcEERKNSt7__cxx1112basic_stringIcS1_SaIcEEEPKcmmmmiiiiiSB_iRK12SearchResultdd
	.type	_Z16write_result_rowRSt14basic_ofstreamIcSt11char_traitsIcEERKNSt7__cxx1112basic_stringIcS1_SaIcEEEPKcmmmmiiiiiSB_iRK12SearchResultdd, %function
_Z16write_result_rowRSt14basic_ofstreamIcSt11char_traitsIcEERKNSt7__cxx1112basic_stringIcS1_SaIcEEEPKcmmmmiiiiiSB_iRK12SearchResultdd:
.LFB10469:
	.cfi_startproc
	stp	x29, x30, [sp, -176]!
	.cfi_def_cfa_offset 176
	.cfi_offset 29, -176
	.cfi_offset 30, -168
	mov	x9, x2
	mov	x29, sp
	ldp	x1, x2, [x1]
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -128
	.cfi_offset 24, -120
	mov	x24, x6
	mov	w23, w7
	ldr	w6, [sp, 184]
	ldr	w7, [sp, 176]
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -112
	.cfi_offset 26, -104
	mov	x26, x5
	ldr	w5, [sp, 192]
	stp	d8, d9, [sp, 96]
	.cfi_offset 72, -80
	.cfi_offset 73, -72
	fmov	d9, d1
	ldr	w25, [sp, 216]
	str	d10, [sp, 112]
	.cfi_offset 74, -64
	fmov	d10, d0
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -160
	.cfi_offset 20, -152
	adrp	x19, .LC13
	add	x19, x19, :lo12:.LC13
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -144
	.cfi_offset 22, -136
	mov	x21, 6
	stp	x27, x28, [sp, 80]
	.cfi_offset 27, -96
	.cfi_offset 28, -88
	ldr	w28, [sp, 200]
	stp	w5, w6, [sp, 140]
	str	w7, [sp, 148]
	stp	x4, x3, [sp, 152]
	str	x9, [sp, 168]
	ldr	x27, [sp, 208]
	ldr	x22, [sp, 224]
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	mov	x1, x19
	mov	x20, x0
	mov	x2, 1
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	ldr	x9, [sp, 168]
	mov	x0, x20
	mov	x1, x9
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	mov	x20, x0
	mov	x1, x19
	mov	x2, 1
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	ldr	x3, [sp, 160]
	mov	x0, x20
	mov	x1, x3
	bl	_ZNSo9_M_insertImEERSoT_
	mov	x20, x0
	mov	x1, x19
	mov	x2, 1
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	ldr	x4, [sp, 152]
	mov	x0, x20
	mov	x1, x4
	bl	_ZNSo9_M_insertImEERSoT_
	mov	x20, x0
	mov	x2, 1
	mov	x1, x19
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	mov	x1, x26
	mov	x0, x20
	bl	_ZNSo9_M_insertImEERSoT_
	mov	x20, x0
	mov	x2, 1
	mov	x1, x19
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	mov	x1, x24
	mov	x0, x20
	bl	_ZNSo9_M_insertImEERSoT_
	mov	x20, x0
	mov	x2, 1
	mov	x1, x19
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	mov	w1, w23
	mov	x0, x20
	bl	_ZNSolsEi
	mov	x20, x0
	mov	x1, x19
	mov	x2, 1
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	ldr	w7, [sp, 148]
	mov	x0, x20
	mov	w1, w7
	bl	_ZNSolsEi
	mov	x20, x0
	mov	x1, x19
	mov	x2, 1
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	ldr	w6, [sp, 144]
	mov	x0, x20
	mov	w1, w6
	bl	_ZNSolsEi
	mov	x20, x0
	mov	x1, x19
	mov	x2, 1
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	ldr	w5, [sp, 140]
	mov	x0, x20
	mov	w1, w5
	bl	_ZNSolsEi
	mov	x20, x0
	mov	x2, 1
	mov	x1, x19
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	mov	w1, w28
	mov	x0, x20
	bl	_ZNSolsEi
	mov	x20, x0
	mov	x2, 1
	mov	x1, x19
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	mov	x1, x27
	mov	x0, x20
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	mov	x20, x0
	mov	x2, 1
	mov	x1, x19
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	mov	w1, w25
	mov	x0, x20
	bl	_ZNSolsEi
	mov	x20, x0
	mov	x1, x19
	mov	x2, 1
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	ldr	d0, [x22, 8]
	mov	x0, 70368744177664
	movk	x0, 0x408f, lsl 48
	fmov	d8, x0
	ldr	x1, [x20]
	scvtf	d0, d0
	mov	x0, x20
	mov	w2, -261
	ldr	x1, [x1, -24]
	fdiv	d0, d0, d8
	add	x20, x20, x1
	ldr	w1, [x20, 24]
	str	x21, [x20, 8]
	and	w1, w1, w2
	orr	w1, w1, 4
	str	w1, [x20, 24]
	bl	_ZNSo9_M_insertIdEERSoT_
	mov	x20, x0
	mov	x1, x19
	mov	x2, 1
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	ldr	x1, [x20]
	mov	x0, x20
	ldr	s0, [x22]
	ldr	x1, [x1, -24]
	fcvt	d0, s0
	add	x20, x20, x1
	str	x21, [x20, 8]
	bl	_ZNSo9_M_insertIdEERSoT_
	mov	x20, x0
	mov	x1, x19
	mov	x2, 1
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	fmov	d0, d10
	ldr	x1, [x20]
	mov	x0, x20
	ldr	x1, [x1, -24]
	add	x20, x20, x1
	str	x21, [x20, 8]
	bl	_ZNSo9_M_insertIdEERSoT_
	mov	x20, x0
	mov	x1, x19
	mov	x2, 1
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	fmov	d0, d9
	ldr	x1, [x20]
	mov	x0, x20
	ldr	x1, [x1, -24]
	add	x20, x20, x1
	str	x21, [x20, 8]
	bl	_ZNSo9_M_insertIdEERSoT_
	mov	x20, x0
	mov	x1, x19
	mov	x2, 1
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	ldr	d0, [x22, 16]
	mov	x0, x20
	ldr	x1, [x20]
	scvtf	d0, d0
	ldr	x1, [x1, -24]
	fdiv	d0, d0, d8
	add	x20, x20, x1
	str	x21, [x20, 8]
	bl	_ZNSo9_M_insertIdEERSoT_
	mov	x20, x0
	mov	x1, x19
	mov	x2, 1
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	ldr	d0, [x22, 24]
	mov	x0, x20
	ldr	x1, [x20]
	scvtf	d0, d0
	ldr	x1, [x1, -24]
	fdiv	d0, d0, d8
	add	x20, x20, x1
	str	x21, [x20, 8]
	bl	_ZNSo9_M_insertIdEERSoT_
	mov	x20, x0
	mov	x2, 1
	mov	x1, x19
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	mov	x0, x20
	mov	w1, 0
	bl	_ZNSolsEi
	mov	x20, x0
	mov	x2, 1
	mov	x1, x19
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	mov	x0, x20
	mov	w1, 0
	bl	_ZNSolsEi
	mov	x20, x0
	mov	x2, 1
	mov	x1, x19
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	mov	x0, x20
	mov	w1, 0
	bl	_ZNSolsEi
	mov	x20, x0
	mov	x2, 1
	mov	x1, x19
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	mov	x0, x20
	mov	w1, 0
	bl	_ZNSolsEi
	mov	x2, 1
	mov	x1, x19
	mov	x19, x0
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	mov	x0, x19
	mov	w1, 0
	bl	_ZNSolsEi
	ldp	x19, x20, [sp, 16]
	adrp	x1, .LC10
	ldp	x21, x22, [sp, 32]
	add	x1, x1, :lo12:.LC10
	ldp	x23, x24, [sp, 48]
	mov	x2, 1
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	d8, d9, [sp, 96]
	ldr	d10, [sp, 112]
	ldp	x29, x30, [sp], 176
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_restore 74
	.cfi_restore 72
	.cfi_restore 73
	.cfi_def_cfa_offset 0
	b	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	.cfi_endproc
.LFE10469:
	.size	_Z16write_result_rowRSt14basic_ofstreamIcSt11char_traitsIcEERKNSt7__cxx1112basic_stringIcS1_SaIcEEEPKcmmmmiiiiiSB_iRK12SearchResultdd, .-_Z16write_result_rowRSt14basic_ofstreamIcSt11char_traitsIcEERKNSt7__cxx1112basic_stringIcS1_SaIcEEEPKcmmmmiiiiiSB_iRK12SearchResultdd
	.section	.rodata._ZStplIcSt11char_traitsIcESaIcEENSt7__cxx1112basic_stringIT_T0_T1_EERKS8_PKS5_.str1.8,"aMS",@progbits,1
	.align	3
.LC14:
	.string	"basic_string::_M_construct null not valid"
	.section	.text._ZStplIcSt11char_traitsIcESaIcEENSt7__cxx1112basic_stringIT_T0_T1_EERKS8_PKS5_,"axG",@progbits,_ZStplIcSt11char_traitsIcESaIcEENSt7__cxx1112basic_stringIT_T0_T1_EERKS8_PKS5_,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZStplIcSt11char_traitsIcESaIcEENSt7__cxx1112basic_stringIT_T0_T1_EERKS8_PKS5_
	.type	_ZStplIcSt11char_traitsIcESaIcEENSt7__cxx1112basic_stringIT_T0_T1_EERKS8_PKS5_, %function
_ZStplIcSt11char_traitsIcESaIcEENSt7__cxx1112basic_stringIT_T0_T1_EERKS8_PKS5_:
.LFB10710:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA10710
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	stp	x21, x22, [sp, 32]
	.cfi_offset 19, -64
	.cfi_offset 20, -56
	.cfi_offset 21, -48
	.cfi_offset 22, -40
	add	x22, x8, 16
	ldr	x20, [x0, 8]
	str	x23, [sp, 48]
	.cfi_offset 23, -32
	str	x22, [x8]
	ldr	x23, [x0]
	cmn	x23, x20
	ccmp	x23, 0, 0, ne
	beq	.L264
	str	x20, [sp, 72]
	mov	x19, x8
	mov	x21, x1
	cmp	x20, 15
	bhi	.L265
	cmp	x20, 1
	bne	.L254
	ldrb	w1, [x23]
	mov	x0, x22
	strb	w1, [x8, 16]
.L255:
	str	x20, [x19, 8]
	strb	wzr, [x0, x20]
	mov	x0, x21
	bl	strlen
	mov	x2, x0
	ldr	x1, [x19, 8]
	mov	x0, 4611686018427387903
	sub	x0, x0, x1
	cmp	x2, x0
	bhi	.L266
	mov	x1, x21
	mov	x0, x19
.LEHB4:
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE9_M_appendEPKcm
.LEHE4:
	mov	x0, x19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 80
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L254:
	.cfi_restore_state
	mov	x0, x22
	cbz	x20, .L255
	b	.L253
	.p2align 2,,3
.L265:
	add	x1, sp, 72
	mov	x0, x8
	mov	x2, 0
.LEHB5:
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE9_M_createERmm
.LEHE5:
	ldr	x1, [sp, 72]
	str	x0, [x19]
	str	x1, [x19, 16]
.L253:
	mov	x2, x20
	mov	x1, x23
	bl	memcpy
	ldr	x0, [x19]
	ldr	x20, [sp, 72]
	b	.L255
.L266:
	adrp	x0, .LC7
	add	x0, x0, :lo12:.LC7
.LEHB6:
	bl	_ZSt20__throw_length_errorPKc
.LEHE6:
.L264:
	adrp	x0, .LC14
	add	x0, x0, :lo12:.LC14
.LEHB7:
	bl	_ZSt19__throw_logic_errorPKc
.L260:
	ldr	x1, [x19]
	mov	x19, x0
	cmp	x1, x22
	beq	.L258
	mov	x0, x1
	bl	_ZdlPv
.L258:
	mov	x0, x19
	bl	_Unwind_Resume
.LEHE7:
	.cfi_endproc
.LFE10710:
	.section	.gcc_except_table
.LLSDA10710:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE10710-.LLSDACSB10710
.LLSDACSB10710:
	.uleb128 .LEHB4-.LFB10710
	.uleb128 .LEHE4-.LEHB4
	.uleb128 .L260-.LFB10710
	.uleb128 0
	.uleb128 .LEHB5-.LFB10710
	.uleb128 .LEHE5-.LEHB5
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB6-.LFB10710
	.uleb128 .LEHE6-.LEHB6
	.uleb128 .L260-.LFB10710
	.uleb128 0
	.uleb128 .LEHB7-.LFB10710
	.uleb128 .LEHE7-.LEHB7
	.uleb128 0
	.uleb128 0
.LLSDACSE10710:
	.section	.text._ZStplIcSt11char_traitsIcESaIcEENSt7__cxx1112basic_stringIT_T0_T1_EERKS8_PKS5_,"axG",@progbits,_ZStplIcSt11char_traitsIcESaIcEENSt7__cxx1112basic_stringIT_T0_T1_EERKS8_PKS5_,comdat
	.size	_ZStplIcSt11char_traitsIcESaIcEENSt7__cxx1112basic_stringIT_T0_T1_EERKS8_PKS5_, .-_ZStplIcSt11char_traitsIcESaIcEENSt7__cxx1112basic_stringIT_T0_T1_EERKS8_PKS5_
	.section	.rodata.str1.8
	.align	3
.LC15:
	.string	"/results"
	.align	3
.LC16:
	.string	"/results/alignment_report.md"
	.align	3
.LC17:
	.string	"# SIMD Alignment Report\n\n"
	.align	3
.LC18:
	.string	"This file is generated by `main.cc` during `bash test.sh 1 1`.\n\n"
	.align	3
.LC19:
	.string	"| item | value |\n"
	.align	3
.LC20:
	.string	"|---|---:|\n"
	.align	3
.LC21:
	.string	"| base address mod 16 | "
	.align	3
.LC22:
	.string	" |\n"
	.align	3
.LC23:
	.string	"| base address mod 32 | "
	.align	3
.LC24:
	.string	"| base address mod 64 | "
	.align	3
.LC25:
	.string	"| query address mod 16 | "
	.align	3
.LC26:
	.string	"| query address mod 32 | "
	.align	3
.LC27:
	.string	"| query address mod 64 | "
	.align	3
.LC28:
	.string	"| vector stride bytes | "
	.align	3
.LC29:
	.string	"| stride mod 16 | "
	.align	3
.LC30:
	.string	"| stride mod 32 | "
	.align	3
.LC31:
	.string	"| stride mod 64 | "
	.align	3
.LC32:
	.string	"| base vectors checked | "
	.align	3
.LC33:
	.string	" |\n\n"
	.align	3
.LC34:
	.string	"The NEON aligned-hint benchmark uses 16-byte alignment checks and falls back "
	.align	3
.LC35:
	.string	"to the safe unaligned NEON path if either pointer is not aligned.\n"
	.text
	.align	2
	.p2align 4,,11
	.global	_Z22write_alignment_reportRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEPKfS8_mm
	.type	_Z22write_alignment_reportRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEPKfS8_mm, %function
_Z22write_alignment_reportRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEPKfS8_mm:
.LFB10470:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA10470
	sub	sp, sp, #640
	.cfi_def_cfa_offset 640
	stp	x29, x30, [sp]
	.cfi_offset 29, -640
	.cfi_offset 30, -632
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -624
	.cfi_offset 20, -616
	mov	x20, x0
	add	x0, sp, 136
	stp	x21, x22, [sp, 32]
	ldr	x19, [x20, 8]
	str	x25, [sp, 64]
	.cfi_offset 21, -608
	.cfi_offset 22, -600
	.cfi_offset 25, -576
	ldr	x25, [x20]
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -592
	.cfi_offset 24, -584
	str	x0, [sp, 120]
	cmn	x25, x19
	ccmp	x25, 0, 0, ne
	beq	.L278
	str	x19, [sp, 88]
	mov	x23, x1
	mov	x22, x2
	mov	x24, x3
	mov	x21, x4
	cmp	x19, 15
	bhi	.L314
	cmp	x19, 1
	bne	.L271
	ldrb	w2, [x25]
	mov	x1, x0
	strb	w2, [sp, 136]
.L272:
	str	x19, [sp, 128]
	mov	x0, 4611686018427387903
	strb	wzr, [x1, x19]
	ldr	x1, [sp, 128]
	sub	x0, x0, x1
	cmp	x0, 7
	bls	.L315
	adrp	x1, .LC15
	add	x0, sp, 120
	add	x1, x1, :lo12:.LC15
	mov	x2, 8
.LEHB8:
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE9_M_appendEPKcm
.LEHE8:
	add	x0, sp, 120
.LEHB9:
	bl	_Z10ensure_dirRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
.LEHE9:
	ldr	x0, [sp, 120]
	add	x1, sp, 136
	cmp	x0, x1
	beq	.L277
	bl	_ZdlPv
.L277:
	ldp	x25, x19, [x20]
	add	x0, sp, 104
	str	x0, [sp, 88]
	cmn	x25, x19
	ccmp	x25, 0, 0, ne
	beq	.L278
	str	x19, [sp, 120]
	cmp	x19, 15
	bhi	.L316
	cmp	x19, 1
	bne	.L281
	ldrb	w2, [x25]
	mov	x1, x0
	strb	w2, [sp, 104]
.L282:
	str	x19, [sp, 96]
	mov	x0, 4611686018427387903
	strb	wzr, [x1, x19]
	ldr	x1, [sp, 96]
	sub	x0, x0, x1
	cmp	x0, 27
	bls	.L317
	adrp	x1, .LC16
	add	x0, sp, 88
	add	x1, x1, :lo12:.LC16
	mov	x2, 28
.LEHB10:
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE9_M_appendEPKcm
.LEHE10:
	ldr	x1, [sp, 88]
	add	x0, sp, 120
	mov	w2, 48
.LEHB11:
	bl	_ZNSt14basic_ofstreamIcSt11char_traitsIcEEC1EPKcSt13_Ios_Openmode
.LEHE11:
	ldr	x0, [sp, 88]
	add	x1, sp, 104
	cmp	x0, x1
	beq	.L287
	bl	_ZdlPv
.L287:
	add	x0, sp, 240
	bl	_ZNKSt12__basic_fileIcE7is_openEv
	tst	w0, 255
	beq	.L318
	adrp	x1, .LC17
	lsl	x21, x21, 2
	add	x0, sp, 120
	add	x1, x1, :lo12:.LC17
.LEHB12:
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	adrp	x1, .LC18
	add	x0, sp, 120
	add	x1, x1, :lo12:.LC18
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	adrp	x1, .LC19
	add	x0, sp, 120
	add	x1, x1, :lo12:.LC19
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	adrp	x1, .LC20
	add	x0, sp, 120
	add	x1, x1, :lo12:.LC20
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	adrp	x1, .LC21
	add	x0, sp, 120
	add	x1, x1, :lo12:.LC21
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	and	x1, x23, 15
	bl	_ZNSo9_M_insertImEERSoT_
	adrp	x19, .LC22
	add	x19, x19, :lo12:.LC22
	mov	x1, x19
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	adrp	x1, .LC23
	add	x0, sp, 120
	add	x1, x1, :lo12:.LC23
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	and	x1, x23, 31
	bl	_ZNSo9_M_insertImEERSoT_
	mov	x1, x19
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	adrp	x1, .LC24
	add	x0, sp, 120
	add	x1, x1, :lo12:.LC24
	mov	x2, 24
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	and	x1, x23, 63
	add	x0, sp, 120
	bl	_ZNSo9_M_insertImEERSoT_
	mov	x1, x19
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	adrp	x1, .LC25
	add	x0, sp, 120
	add	x1, x1, :lo12:.LC25
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	and	x1, x22, 15
	bl	_ZNSo9_M_insertImEERSoT_
	mov	x1, x19
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	adrp	x1, .LC26
	add	x0, sp, 120
	add	x1, x1, :lo12:.LC26
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	and	x1, x22, 31
	bl	_ZNSo9_M_insertImEERSoT_
	mov	x1, x19
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	adrp	x1, .LC27
	add	x0, sp, 120
	add	x1, x1, :lo12:.LC27
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	and	x1, x22, 63
	bl	_ZNSo9_M_insertImEERSoT_
	mov	x1, x19
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	adrp	x1, .LC28
	add	x0, sp, 120
	add	x1, x1, :lo12:.LC28
	mov	x2, 24
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	mov	x1, x21
	add	x0, sp, 120
	bl	_ZNSo9_M_insertImEERSoT_
	mov	x1, x19
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	adrp	x1, .LC29
	add	x0, sp, 120
	add	x1, x1, :lo12:.LC29
	mov	x2, 18
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	and	x1, x21, 12
	add	x0, sp, 120
	bl	_ZNSo9_M_insertImEERSoT_
	mov	x1, x19
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	adrp	x1, .LC30
	add	x0, sp, 120
	add	x1, x1, :lo12:.LC30
	mov	x2, 18
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	and	x1, x21, 28
	add	x0, sp, 120
	bl	_ZNSo9_M_insertImEERSoT_
	mov	x1, x19
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	adrp	x1, .LC31
	add	x0, sp, 120
	add	x1, x1, :lo12:.LC31
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	and	x1, x21, 60
	bl	_ZNSo9_M_insertImEERSoT_
	mov	x1, x19
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	adrp	x1, .LC32
	add	x0, sp, 120
	add	x1, x1, :lo12:.LC32
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	mov	x1, x24
	bl	_ZNSo9_M_insertImEERSoT_
	adrp	x1, .LC33
	add	x1, x1, :lo12:.LC33
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	adrp	x1, .LC34
	add	x0, sp, 120
	add	x1, x1, :lo12:.LC34
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	adrp	x1, .LC35
	add	x1, x1, :lo12:.LC35
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
.LEHE12:
	adrp	x3, _ZTVSt14basic_ofstreamIcSt11char_traitsIcEE+24
	adrp	x1, _ZTVSt14basic_ofstreamIcSt11char_traitsIcEE+64
	add	x3, x3, :lo12:_ZTVSt14basic_ofstreamIcSt11char_traitsIcEE+24
	add	x1, x1, :lo12:_ZTVSt14basic_ofstreamIcSt11char_traitsIcEE+64
	adrp	x2, _ZTVSt13basic_filebufIcSt11char_traitsIcEE+16
	add	x2, x2, :lo12:_ZTVSt13basic_filebufIcSt11char_traitsIcEE+16
	add	x0, sp, 128
	stp	x3, x2, [sp, 120]
	str	x1, [sp, 376]
.LEHB13:
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEE5closeEv
.LEHE13:
.L291:
	add	x0, sp, 240
	bl	_ZNSt12__basic_fileIcED1Ev
	adrp	x1, _ZTVSt15basic_streambufIcSt11char_traitsIcEE+16
	add	x1, x1, :lo12:_ZTVSt15basic_streambufIcSt11char_traitsIcEE+16
	add	x0, sp, 184
	str	x1, [sp, 128]
	bl	_ZNSt6localeD1Ev
	adrp	x1, _ZTTSt14basic_ofstreamIcSt11char_traitsIcEE
	add	x1, x1, :lo12:_ZTTSt14basic_ofstreamIcSt11char_traitsIcEE
	adrp	x2, _ZTVSt9basic_iosIcSt11char_traitsIcEE+16
	add	x2, x2, :lo12:_ZTVSt9basic_iosIcSt11char_traitsIcEE+16
	add	x0, sp, 376
	ldp	x3, x4, [x1, 8]
	ldr	x1, [x3, -24]
	str	x3, [sp, 120]
	add	x3, sp, 120
	str	x4, [x3, x1]
	str	x2, [sp, 376]
	bl	_ZNSt8ios_baseD2Ev
	ldp	x29, x30, [sp]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	add	sp, sp, 640
	.cfi_remember_state
	.cfi_restore 29
	.cfi_restore 30
	.cfi_restore 25
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L271:
	.cfi_restore_state
	mov	x1, x0
	cbz	x19, .L272
	b	.L270
	.p2align 2,,3
.L318:
	add	x0, sp, 120
	bl	_ZNSt14basic_ofstreamIcSt11char_traitsIcEED1Ev
	ldp	x29, x30, [sp]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	add	sp, sp, 640
	.cfi_remember_state
	.cfi_restore 29
	.cfi_restore 30
	.cfi_restore 25
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L281:
	.cfi_restore_state
	mov	x1, x0
	cbz	x19, .L282
	b	.L280
	.p2align 2,,3
.L314:
	add	x1, sp, 88
	add	x0, sp, 120
	mov	x2, 0
.LEHB14:
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE9_M_createERmm
	ldr	x1, [sp, 88]
	str	x0, [sp, 120]
	str	x1, [sp, 136]
.L270:
	mov	x2, x19
	mov	x1, x25
	bl	memcpy
	ldr	x19, [sp, 88]
	ldr	x1, [sp, 120]
	b	.L272
	.p2align 2,,3
.L316:
	add	x1, sp, 120
	add	x0, sp, 88
	mov	x2, 0
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE9_M_createERmm
.LEHE14:
	ldr	x1, [sp, 120]
	str	x0, [sp, 88]
	str	x1, [sp, 104]
.L280:
	mov	x2, x19
	mov	x1, x25
	bl	memcpy
	ldr	x1, [sp, 88]
	ldr	x19, [sp, 120]
	b	.L282
.L315:
	adrp	x0, .LC7
	add	x0, x0, :lo12:.LC7
.LEHB15:
	bl	_ZSt20__throw_length_errorPKc
.LEHE15:
.L317:
	adrp	x0, .LC7
	add	x0, x0, :lo12:.LC7
.LEHB16:
	bl	_ZSt20__throw_length_errorPKc
.LEHE16:
.L278:
	adrp	x0, .LC14
	add	x0, x0, :lo12:.LC14
.LEHB17:
	bl	_ZSt19__throw_logic_errorPKc
.L302:
.L313:
	ldr	x1, [sp, 120]
	add	x2, sp, 136
	mov	x19, x0
	cmp	x1, x2
	beq	.L310
.L311:
	mov	x0, x1
	bl	_ZdlPv
	b	.L310
.L299:
	b	.L313
.L300:
	ldr	x2, [sp, 88]
	add	x1, sp, 104
	mov	x19, x0
	cmp	x2, x1
	beq	.L310
	mov	x0, x2
	bl	_ZdlPv
	b	.L310
.L301:
	mov	x19, x0
	add	x0, sp, 120
	bl	_ZNSt14basic_ofstreamIcSt11char_traitsIcEED1Ev
.L310:
	mov	x0, x19
	bl	_Unwind_Resume
.LEHE17:
.L304:
	bl	__cxa_begin_catch
	bl	__cxa_end_catch
	b	.L291
.L303:
	ldr	x1, [sp, 88]
	add	x2, sp, 104
	mov	x19, x0
	cmp	x1, x2
	bne	.L311
	b	.L310
	.cfi_endproc
.LFE10470:
	.section	.gcc_except_table
	.align	2
.LLSDA10470:
	.byte	0xff
	.byte	0x9b
	.uleb128 .LLSDATT10470-.LLSDATTD10470
.LLSDATTD10470:
	.byte	0x1
	.uleb128 .LLSDACSE10470-.LLSDACSB10470
.LLSDACSB10470:
	.uleb128 .LEHB8-.LFB10470
	.uleb128 .LEHE8-.LEHB8
	.uleb128 .L302-.LFB10470
	.uleb128 0
	.uleb128 .LEHB9-.LFB10470
	.uleb128 .LEHE9-.LEHB9
	.uleb128 .L299-.LFB10470
	.uleb128 0
	.uleb128 .LEHB10-.LFB10470
	.uleb128 .LEHE10-.LEHB10
	.uleb128 .L303-.LFB10470
	.uleb128 0
	.uleb128 .LEHB11-.LFB10470
	.uleb128 .LEHE11-.LEHB11
	.uleb128 .L300-.LFB10470
	.uleb128 0
	.uleb128 .LEHB12-.LFB10470
	.uleb128 .LEHE12-.LEHB12
	.uleb128 .L301-.LFB10470
	.uleb128 0
	.uleb128 .LEHB13-.LFB10470
	.uleb128 .LEHE13-.LEHB13
	.uleb128 .L304-.LFB10470
	.uleb128 0x1
	.uleb128 .LEHB14-.LFB10470
	.uleb128 .LEHE14-.LEHB14
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB15-.LFB10470
	.uleb128 .LEHE15-.LEHB15
	.uleb128 .L302-.LFB10470
	.uleb128 0
	.uleb128 .LEHB16-.LFB10470
	.uleb128 .LEHE16-.LEHB16
	.uleb128 .L303-.LFB10470
	.uleb128 0
	.uleb128 .LEHB17-.LFB10470
	.uleb128 .LEHE17-.LEHB17
	.uleb128 0
	.uleb128 0
.LLSDACSE10470:
	.byte	0x1
	.byte	0
	.align	2
	.4byte	0

.LLSDATT10470:
	.text
	.size	_Z22write_alignment_reportRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEPKfS8_mm, .-_Z22write_alignment_reportRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEPKfS8_mm
	.section	.text._ZNSt7__cxx1115basic_stringbufIcSt11char_traitsIcESaIcEED2Ev,"axG",@progbits,_ZNSt7__cxx1115basic_stringbufIcSt11char_traitsIcESaIcEED5Ev,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt7__cxx1115basic_stringbufIcSt11char_traitsIcESaIcEED2Ev
	.type	_ZNSt7__cxx1115basic_stringbufIcSt11char_traitsIcESaIcEED2Ev, %function
_ZNSt7__cxx1115basic_stringbufIcSt11char_traitsIcESaIcEED2Ev:
.LFB10998:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	add	x2, x0, 88
	adrp	x1, _ZTVNSt7__cxx1115basic_stringbufIcSt11char_traitsIcESaIcEEE+16
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	mov	x19, x0
	ldr	x0, [x0, 72]
	add	x1, x1, :lo12:_ZTVNSt7__cxx1115basic_stringbufIcSt11char_traitsIcESaIcEEE+16
	str	x1, [x19]
	cmp	x0, x2
	beq	.L320
	bl	_ZdlPv
.L320:
	mov	x0, x19
	adrp	x1, _ZTVSt15basic_streambufIcSt11char_traitsIcEE+16
	add	x1, x1, :lo12:_ZTVSt15basic_streambufIcSt11char_traitsIcEE+16
	ldr	x19, [sp, 16]
	str	x1, [x0], 56
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	b	_ZNSt6localeD1Ev
	.cfi_endproc
.LFE10998:
	.size	_ZNSt7__cxx1115basic_stringbufIcSt11char_traitsIcESaIcEED2Ev, .-_ZNSt7__cxx1115basic_stringbufIcSt11char_traitsIcESaIcEED2Ev
	.weak	_ZNSt7__cxx1115basic_stringbufIcSt11char_traitsIcESaIcEED1Ev
	.set	_ZNSt7__cxx1115basic_stringbufIcSt11char_traitsIcESaIcEED1Ev,_ZNSt7__cxx1115basic_stringbufIcSt11char_traitsIcESaIcEED2Ev
	.section	.text._ZNSt7__cxx1115basic_stringbufIcSt11char_traitsIcESaIcEED0Ev,"axG",@progbits,_ZNSt7__cxx1115basic_stringbufIcSt11char_traitsIcESaIcEED5Ev,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt7__cxx1115basic_stringbufIcSt11char_traitsIcESaIcEED0Ev
	.type	_ZNSt7__cxx1115basic_stringbufIcSt11char_traitsIcESaIcEED0Ev, %function
_ZNSt7__cxx1115basic_stringbufIcSt11char_traitsIcESaIcEED0Ev:
.LFB11000:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	add	x2, x0, 88
	adrp	x1, _ZTVNSt7__cxx1115basic_stringbufIcSt11char_traitsIcESaIcEEE+16
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	mov	x19, x0
	ldr	x0, [x0, 72]
	add	x1, x1, :lo12:_ZTVNSt7__cxx1115basic_stringbufIcSt11char_traitsIcESaIcEEE+16
	str	x1, [x19]
	cmp	x0, x2
	beq	.L323
	bl	_ZdlPv
.L323:
	mov	x0, x19
	adrp	x1, _ZTVSt15basic_streambufIcSt11char_traitsIcEE+16
	add	x1, x1, :lo12:_ZTVSt15basic_streambufIcSt11char_traitsIcEE+16
	str	x1, [x0], 56
	bl	_ZNSt6localeD1Ev
	mov	x0, x19
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	b	_ZdlPv
	.cfi_endproc
.LFE11000:
	.size	_ZNSt7__cxx1115basic_stringbufIcSt11char_traitsIcESaIcEED0Ev, .-_ZNSt7__cxx1115basic_stringbufIcSt11char_traitsIcESaIcEED0Ev
	.section	.text._ZNSt11unique_lockISt5mutexE4lockEv,"axG",@progbits,_ZNSt11unique_lockISt5mutexE4lockEv,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt11unique_lockISt5mutexE4lockEv
	.type	_ZNSt11unique_lockISt5mutexE4lockEv, %function
_ZNSt11unique_lockISt5mutexE4lockEv:
.LFB11167:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	mov	x19, x0
	ldr	x0, [x0]
	cbz	x0, .L336
	ldrb	w1, [x19, 8]
	cbnz	w1, .L337
	adrp	x1, .LC36
	ldr	x1, [x1, #:lo12:.LC36]
	cbz	x1, .L328
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L338
.L328:
	mov	w0, 1
	strb	w0, [x19, 8]
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
.L336:
	.cfi_restore_state
	mov	w0, 1
	bl	_ZSt20__throw_system_errori
.L337:
	mov	w0, 35
	bl	_ZSt20__throw_system_errori
.L338:
	bl	_ZSt20__throw_system_errori
	.cfi_endproc
.LFE11167:
	.size	_ZNSt11unique_lockISt5mutexE4lockEv, .-_ZNSt11unique_lockISt5mutexE4lockEv
	.section	.text._ZNSt11unique_lockISt5mutexE6unlockEv,"axG",@progbits,_ZNSt11unique_lockISt5mutexE6unlockEv,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt11unique_lockISt5mutexE6unlockEv
	.type	_ZNSt11unique_lockISt5mutexE6unlockEv, %function
_ZNSt11unique_lockISt5mutexE6unlockEv:
.LFB11168:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	mov	x19, x0
	ldrb	w0, [x0, 8]
	cbz	w0, .L350
	ldr	x0, [x19]
	cbz	x0, .L339
	adrp	x1, .LC36
	ldr	x1, [x1, #:lo12:.LC36]
	cbz	x1, .L342
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
.L342:
	strb	wzr, [x19, 8]
.L339:
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
.L350:
	.cfi_restore_state
	mov	w0, 1
	bl	_ZSt20__throw_system_errori
	.cfi_endproc
.LFE11168:
	.size	_ZNSt11unique_lockISt5mutexE6unlockEv, .-_ZNSt11unique_lockISt5mutexE6unlockEv
	.section	.text._ZN7hnswlib15VisitedListPool18getFreeVisitedListEv,"axG",@progbits,_ZN7hnswlib15VisitedListPool18getFreeVisitedListEv,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib15VisitedListPool18getFreeVisitedListEv
	.type	_ZN7hnswlib15VisitedListPool18getFreeVisitedListEv, %function
_ZN7hnswlib15VisitedListPool18getFreeVisitedListEv:
.LFB4141:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA4141
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	adrp	x1, .LC36
	mov	x29, sp
	ldr	x1, [x1, #:lo12:.LC36]
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -48
	.cfi_offset 20, -40
	mov	x19, x0
	add	x0, x0, 80
	str	x21, [sp, 32]
	.cfi_offset 21, -32
	str	x0, [sp, 48]
	strb	wzr, [sp, 56]
	cbz	x1, .L352
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L377
.L352:
	mov	w1, 1
	strb	w1, [sp, 56]
	ldp	x0, x3, [x19, 48]
	add	x21, x19, 16
	ldr	x4, [x21, 24]
	ldr	x1, [x19, 72]
	ldr	x2, [x19, 16]
	sub	x1, x1, x4
	ldr	x4, [x21, 16]
	sub	x0, x0, x3
	asr	x1, x1, 3
	sub	x1, x1, #1
	asr	x0, x0, 3
	sub	x3, x4, x2
	add	x1, x0, x1, lsl 6
	add	x0, x1, x3, asr 3
	cbnz	x0, .L378
	mov	x0, 24
.LEHB18:
	bl	_Znwm
.LEHE18:
	mov	x20, x0
	ldr	w1, [x19, 128]
	mov	w2, -1
	strh	w2, [x0]
	str	w1, [x20, 16]
	ubfiz	x0, x1, 1, 32
.LEHB19:
	bl	_Znam
.LEHE19:
	str	x0, [x20, 8]
.L356:
	ldrb	w0, [sp, 56]
	cbnz	w0, .L355
	ldrh	w0, [x20]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x20]
	cbz	w0, .L379
.L351:
	mov	x0, x20
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 64
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L378:
	.cfi_restore_state
	sub	x4, x4, #8
	ldr	x20, [x2]
	cmp	x2, x4
	beq	.L354
	add	x2, x2, 8
	str	x2, [x19, 16]
.L355:
	add	x0, sp, 48
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
	ldrh	w0, [x20]
	add	w0, w0, 1
	and	w0, w0, 65535
	strh	w0, [x20]
	cbnz	w0, .L351
.L379:
	ldr	x0, [x20, 8]
	mov	w1, 0
	ldr	w2, [x20, 16]
	lsl	x2, x2, 1
	bl	memset
	ldrh	w0, [x20]
	ldr	x21, [sp, 32]
	add	w0, w0, 1
	strh	w0, [x20]
	mov	x0, x20
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 64
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L354:
	.cfi_restore_state
	ldr	x0, [x19, 24]
	bl	_ZdlPv
	ldr	x0, [x19, 40]
	add	x1, x0, 8
	ldr	x0, [x0, 8]
	str	x0, [x21, 8]
	str	x1, [x21, 24]
	add	x1, x0, 512
	str	x1, [x21, 16]
	str	x0, [x19, 16]
	b	.L356
.L377:
.LEHB20:
	bl	_ZSt20__throw_system_errori
.LEHE20:
.L362:
	mov	x19, x0
	b	.L360
.L363:
	mov	x19, x0
	mov	x0, x20
	bl	_ZdlPv
.L360:
	ldrb	w0, [sp, 56]
	cbz	w0, .L361
	add	x0, sp, 48
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
.L361:
	mov	x0, x19
.LEHB21:
	bl	_Unwind_Resume
.LEHE21:
	.cfi_endproc
.LFE4141:
	.section	.gcc_except_table
.LLSDA4141:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE4141-.LLSDACSB4141
.LLSDACSB4141:
	.uleb128 .LEHB18-.LFB4141
	.uleb128 .LEHE18-.LEHB18
	.uleb128 .L362-.LFB4141
	.uleb128 0
	.uleb128 .LEHB19-.LFB4141
	.uleb128 .LEHE19-.LEHB19
	.uleb128 .L363-.LFB4141
	.uleb128 0
	.uleb128 .LEHB20-.LFB4141
	.uleb128 .LEHE20-.LEHB20
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB21-.LFB4141
	.uleb128 .LEHE21-.LEHB21
	.uleb128 0
	.uleb128 0
.LLSDACSE4141:
	.section	.text._ZN7hnswlib15VisitedListPool18getFreeVisitedListEv,"axG",@progbits,_ZN7hnswlib15VisitedListPool18getFreeVisitedListEv,comdat
	.size	_ZN7hnswlib15VisitedListPool18getFreeVisitedListEv, .-_ZN7hnswlib15VisitedListPool18getFreeVisitedListEv
	.section	.rodata._ZNSt6vectorIhSaIhEE14_M_fill_assignEmRKh.str1.8,"aMS",@progbits,1
	.align	3
.LC37:
	.string	"cannot create std::vector larger than max_size()"
	.section	.text._ZNSt6vectorIhSaIhEE14_M_fill_assignEmRKh,"axG",@progbits,_ZNSt6vectorIhSaIhEE14_M_fill_assignEmRKh,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt6vectorIhSaIhEE14_M_fill_assignEmRKh
	.type	_ZNSt6vectorIhSaIhEE14_M_fill_assignEmRKh, %function
_ZNSt6vectorIhSaIhEE14_M_fill_assignEmRKh:
.LFB11230:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -32
	.cfi_offset 20, -24
	mov	x20, x0
	mov	x19, x1
	ldr	x0, [x0]
	ldr	x1, [x20, 16]
	str	x21, [sp, 32]
	.cfi_offset 21, -16
	mov	x21, x2
	sub	x1, x1, x0
	cmp	x19, x1
	bhi	.L404
	ldr	x3, [x20, 8]
	sub	x2, x3, x0
	cmp	x19, x2
	bhi	.L405
	cbz	x19, .L389
	ldrb	w1, [x21]
	mov	x2, x19
	add	x21, x0, x19
	bl	memset
	ldr	x3, [x20, 8]
	mov	x0, x21
.L389:
	cmp	x0, x3
	beq	.L380
	str	x0, [x20, 8]
.L380:
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L405:
	.cfi_restore_state
	cbnz	x2, .L406
.L387:
	subs	x2, x19, x2
	bne	.L407
	str	x3, [x20, 8]
.L409:
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L404:
	.cfi_restore_state
	cmp	x19, 0
	blt	.L408
	beq	.L390
	mov	x0, x19
	bl	_Znwm
	ldrb	w1, [x21]
	mov	x2, x19
	mov	x21, x0
	add	x19, x0, x19
	bl	memset
	ldr	x0, [x20]
.L383:
	stp	x21, x19, [x20]
	str	x19, [x20, 16]
	cbz	x0, .L380
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	ldp	x29, x30, [sp], 48
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	b	_ZdlPv
	.p2align 2,,3
.L407:
	.cfi_restore_state
	ldrb	w1, [x21]
	mov	x0, x3
	add	x21, x3, x2
	bl	memset
	mov	x3, x21
	str	x3, [x20, 8]
	b	.L409
	.p2align 2,,3
.L406:
	ldrb	w1, [x21]
	bl	memset
	ldp	x2, x3, [x20]
	sub	x2, x3, x2
	b	.L387
	.p2align 2,,3
.L390:
	mov	x21, 0
	mov	x19, 0
	b	.L383
.L408:
	adrp	x0, .LC37
	add	x0, x0, :lo12:.LC37
	bl	_ZSt20__throw_length_errorPKc
	.cfi_endproc
.LFE11230:
	.size	_ZNSt6vectorIhSaIhEE14_M_fill_assignEmRKh, .-_ZNSt6vectorIhSaIhEE14_M_fill_assignEmRKh
	.section	.text._ZNSt6vectorIfSaIfEE14_M_fill_assignEmRKf,"axG",@progbits,_ZNSt6vectorIfSaIfEE14_M_fill_assignEmRKf,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt6vectorIfSaIfEE14_M_fill_assignEmRKf
	.type	_ZNSt6vectorIfSaIfEE14_M_fill_assignEmRKf, %function
_ZNSt6vectorIfSaIfEE14_M_fill_assignEmRKf:
.LFB11231:
	.cfi_startproc
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -32
	.cfi_offset 20, -24
	mov	x19, x0
	mov	x20, x2
	ldr	x3, [x0]
	ldr	x0, [x0, 16]
	sub	x0, x0, x3
	cmp	x1, x0, asr 2
	bhi	.L437
	ldr	x4, [x19, 8]
	sub	x0, x4, x3
	asr	x0, x0, 2
	cmp	x1, x0
	bls	.L418
	ldr	s0, [x2]
	cmp	x3, x4
	beq	.L419
	.p2align 3,,7
.L420:
	str	s0, [x3], 4
	cmp	x4, x3
	bne	.L420
	ldr	s0, [x20]
.L419:
	sub	x1, x1, x0
	add	x1, x4, x1, lsl 2
	cmp	x4, x1
	beq	.L422
	.p2align 3,,7
.L421:
	str	s0, [x4], 4
	cmp	x1, x4
	bne	.L421
.L422:
	str	x1, [x19, 8]
.L410:
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L418:
	.cfi_restore_state
	mov	x0, x3
	cbz	x1, .L423
	add	x0, x3, x1, lsl 2
	ldr	s0, [x2]
	cmp	x3, x0
	beq	.L423
	.p2align 3,,7
.L424:
	str	s0, [x3], 4
	cmp	x0, x3
	bne	.L424
.L423:
	cmp	x4, x0
	beq	.L410
	str	x0, [x19, 8]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 48
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L437:
	.cfi_restore_state
	str	x21, [sp, 32]
	.cfi_offset 21, -16
	mov	x0, 2305843009213693951
	cmp	x1, x0
	bhi	.L438
	lsl	x21, x1, 2
	cbz	x1, .L425
	mov	x0, x21
	bl	_Znwm
	add	x2, x0, x21
	ldr	s0, [x20]
	cmp	x0, x2
	beq	.L414
	mov	x1, x0
	.p2align 3,,7
.L415:
	str	s0, [x1], 4
	cmp	x1, x2
	bne	.L415
.L414:
	ldr	x3, [x19]
.L413:
	stp	x0, x2, [x19]
	str	x2, [x19, 16]
	cbz	x3, .L436
	ldp	x19, x20, [sp, 16]
	mov	x0, x3
	ldr	x21, [sp, 32]
	.cfi_remember_state
	.cfi_restore 21
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	b	_ZdlPv
	.p2align 2,,3
.L436:
	.cfi_restore_state
	ldp	x19, x20, [sp, 16]
	ldr	x21, [sp, 32]
	.cfi_remember_state
	.cfi_restore 21
	ldp	x29, x30, [sp], 48
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L425:
	.cfi_restore_state
	mov	x0, 0
	mov	x2, 0
	b	.L413
.L438:
	adrp	x0, .LC37
	add	x0, x0, :lo12:.LC37
	bl	_ZSt20__throw_length_errorPKc
	.cfi_endproc
.LFE11231:
	.size	_ZNSt6vectorIfSaIfEE14_M_fill_assignEmRKf, .-_ZNSt6vectorIfSaIfEE14_M_fill_assignEmRKf
	.section	.text._ZN3ann15build_sq8_indexEPKfmmRNS_8SQ8IndexE,"axG",@progbits,_ZN3ann15build_sq8_indexEPKfmmRNS_8SQ8IndexE,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN3ann15build_sq8_indexEPKfmmRNS_8SQ8IndexE
	.type	_ZN3ann15build_sq8_indexEPKfmmRNS_8SQ8IndexE, %function
_ZN3ann15build_sq8_indexEPKfmmRNS_8SQ8IndexE:
.LFB10422:
	.cfi_startproc
	stp	x29, x30, [sp, -112]!
	.cfi_def_cfa_offset 112
	.cfi_offset 29, -112
	.cfi_offset 30, -104
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -80
	.cfi_offset 22, -72
	mov	x22, x1
	mul	x1, x1, x2
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -96
	.cfi_offset 20, -88
	mov	x20, x2
	mov	x21, x0
	stp	x23, x24, [sp, 48]
	add	x0, x3, 16
	.cfi_offset 23, -64
	.cfi_offset 24, -56
	mov	x23, x3
	str	x25, [sp, 64]
	.cfi_offset 25, -48
	add	x2, sp, 80
	stp	x22, x20, [x3]
	add	x25, x3, 40
	strb	wzr, [sp, 80]
	bl	_ZNSt6vectorIhSaIhEE14_M_fill_assignEmRKh
	mov	w0, 2139095039
	fmov	s0, w0
	mov	x1, x20
	mov	x0, x25
	add	x2, sp, 80
	str	s0, [sp, 80]
	bl	_ZNSt6vectorIfSaIfEE14_M_fill_assignEmRKf
	fmov	s0, 1.0e+0
	add	x0, x23, 64
	mov	x1, x20
	add	x2, sp, 80
	str	s0, [sp, 80]
	bl	_ZNSt6vectorIfSaIfEE14_M_fill_assignEmRKf
	mov	x0, 2305843009213693951
	cmp	x20, x0
	bhi	.L475
	cbz	x20, .L441
	lsl	x24, x20, 2
	mov	x0, x24
	bl	_Znwm
	mvni	v0.2s, 0x80, lsl 16
	mov	x19, x0
	mov	x2, x19
	add	x0, x0, x24
	.p2align 3,,7
.L443:
	str	s0, [x2], 4
	cmp	x2, x0
	bne	.L443
	cbz	x22, .L445
.L460:
	mov	x5, x21
	mov	x2, 0
	.p2align 3,,7
.L448:
	cbz	x20, .L453
	ldr	x6, [x25]
	mov	x4, 0
	.p2align 3,,7
.L454:
	ldr	s1, [x5, x4, lsl 2]
	ldr	s0, [x6, x4, lsl 2]
	fcmpe	s1, s0
	bmi	.L464
.L449:
	str	s0, [x6, x4, lsl 2]
	ldr	s0, [x19, x4, lsl 2]
	ldr	s1, [x5, x4, lsl 2]
	fcmpe	s1, s0
	bgt	.L465
.L451:
	str	s0, [x19, x4, lsl 2]
	add	x4, x4, 1
	cmp	x20, x4
	bne	.L454
.L453:
	add	x2, x2, 1
	add	x5, x5, x24
	cmp	x22, x2
	bhi	.L448
	cbz	x20, .L476
.L445:
	mov	w0, 48332
	mov	x2, 0
	ldr	x3, [x23, 40]
	movk	w0, 0x2b8c, lsl 16
	ldr	x1, [x23, 64]
	fmov	s2, w0
	mov	w0, 1132396544
	fmov	s3, w0
	.p2align 3,,7
.L458:
	ldr	s0, [x19, x2, lsl 2]
	ldr	s1, [x3, x2, lsl 2]
	fsub	s0, s0, s1
	fcmpe	s0, s2
	bgt	.L466
	fmov	s0, 1.0e+0
.L455:
	str	s0, [x1, x2, lsl 2]
	add	x2, x2, 1
	cmp	x20, x2
	bhi	.L458
	adrp	x0, _ZN3ann15build_sq8_indexEPKfmmRNS_8SQ8IndexE._omp_fn.0
	add	x1, sp, 80
	add	x0, x0, :lo12:_ZN3ann15build_sq8_indexEPKfmmRNS_8SQ8IndexE._omp_fn.0
	mov	w3, 0
	mov	w2, 0
	stp	x21, x22, [sp, 80]
	stp	x20, x23, [sp, 96]
	bl	GOMP_parallel
.L462:
	mov	x0, x19
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 112
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 25
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	b	_ZdlPv
	.p2align 2,,3
.L465:
	.cfi_restore_state
	fmov	s0, s1
	b	.L451
	.p2align 2,,3
.L464:
	fmov	s0, s1
	b	.L449
	.p2align 2,,3
.L466:
	fdiv	s0, s0, s3
	b	.L455
.L476:
	adrp	x0, _ZN3ann15build_sq8_indexEPKfmmRNS_8SQ8IndexE._omp_fn.0
	add	x1, sp, 80
	add	x0, x0, :lo12:_ZN3ann15build_sq8_indexEPKfmmRNS_8SQ8IndexE._omp_fn.0
	mov	w3, 0
	mov	w2, 0
	stp	x21, x22, [sp, 80]
	stp	xzr, x23, [sp, 96]
	bl	GOMP_parallel
	cbnz	x19, .L462
.L439:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 112
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 25
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
.L441:
	.cfi_restore_state
	cbz	x22, .L461
	mov	x19, 0
	mov	x24, 0
	b	.L460
.L461:
	add	x1, sp, 80
	adrp	x0, _ZN3ann15build_sq8_indexEPKfmmRNS_8SQ8IndexE._omp_fn.0
	mov	w3, 0
	add	x0, x0, :lo12:_ZN3ann15build_sq8_indexEPKfmmRNS_8SQ8IndexE._omp_fn.0
	mov	w2, 0
	stp	x21, xzr, [sp, 80]
	stp	xzr, x23, [sp, 96]
	bl	GOMP_parallel
	b	.L439
.L475:
	adrp	x0, .LC37
	add	x0, x0, :lo12:.LC37
	bl	_ZSt20__throw_length_errorPKc
	.cfi_endproc
.LFE10422:
	.size	_ZN3ann15build_sq8_indexEPKfmmRNS_8SQ8IndexE, .-_ZN3ann15build_sq8_indexEPKfmmRNS_8SQ8IndexE
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE9saveIndexERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE9saveIndexERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib15HierarchicalNSWIfE9saveIndexERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
	.type	_ZN7hnswlib15HierarchicalNSWIfE9saveIndexERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE, %function
_ZN7hnswlib15HierarchicalNSWIfE9saveIndexERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE:
.LFB11072:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA11072
	sub	sp, sp, #608
	.cfi_def_cfa_offset 608
	stp	x29, x30, [sp]
	.cfi_offset 29, -608
	.cfi_offset 30, -600
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -592
	.cfi_offset 20, -584
	mov	x19, x1
	mov	x20, x0
	add	x0, sp, 344
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	.cfi_offset 21, -576
	.cfi_offset 22, -568
	.cfi_offset 23, -560
	.cfi_offset 24, -552
	adrp	x23, _ZTVSt9basic_iosIcSt11char_traitsIcEE+16
	add	x23, x23, :lo12:_ZTVSt9basic_iosIcSt11char_traitsIcEE+16
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -544
	.cfi_offset 26, -536
	bl	_ZNSt8ios_baseC2Ev
	adrp	x2, _ZTTSt14basic_ofstreamIcSt11char_traitsIcEE
	add	x2, x2, :lo12:_ZTTSt14basic_ofstreamIcSt11char_traitsIcEE
	strh	wzr, [sp, 568]
	add	x4, sp, 576
	add	x0, sp, 88
	mov	x1, 0
	ldp	x22, x26, [x2, 8]
	add	x2, sp, 88
	ldr	x3, [x22, -24]
	stp	xzr, xzr, [x4]
	stp	xzr, xzr, [x4, 16]
	add	x0, x0, x3
	str	x22, [sp, 88]
	str	x23, [sp, 344]
	str	xzr, [sp, 560]
	str	x26, [x2, x3]
.LEHB22:
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE4initEPSt15basic_streambufIcS1_E
.LEHE22:
	adrp	x25, _ZTVSt14basic_ofstreamIcSt11char_traitsIcEE+24
	adrp	x24, _ZTVSt14basic_ofstreamIcSt11char_traitsIcEE+64
	add	x25, x25, :lo12:_ZTVSt14basic_ofstreamIcSt11char_traitsIcEE+24
	add	x24, x24, :lo12:_ZTVSt14basic_ofstreamIcSt11char_traitsIcEE+64
	add	x0, sp, 96
	str	x25, [sp, 88]
	str	x24, [sp, 344]
.LEHB23:
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEEC1Ev
.LEHE23:
	add	x0, sp, 88
	add	x1, sp, 96
	add	x0, x0, 256
.LEHB24:
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE4initEPSt15basic_streambufIcS1_E
	ldr	x1, [x19]
	add	x0, sp, 96
	mov	w2, 20
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEE4openEPKcSt13_Ios_Openmode
	mov	x2, x0
	ldr	x0, [sp, 88]
	ldr	x1, [x0, -24]
	add	x0, sp, 88
	add	x0, x0, x1
	cbz	x2, .L504
	mov	w1, 0
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE5clearESt12_Ios_Iostate
.LEHE24:
.L479:
	add	x1, x20, 240
	add	x0, sp, 88
	mov	x2, 8
.LEHB25:
	bl	_ZNSo5writeEPKcl
	mov	x2, 8
	add	x0, sp, 88
	add	x1, x20, x2
	bl	_ZNSo5writeEPKcl
	add	x21, x20, 16
	add	x0, sp, 88
	mov	x1, x21
	mov	x2, 8
	bl	_ZNSo5writeEPKcl
	add	x1, x20, 24
	add	x0, sp, 88
	mov	x2, 8
	bl	_ZNSo5writeEPKcl
	add	x1, x20, 248
	add	x0, sp, 88
	mov	x2, 8
	bl	_ZNSo5writeEPKcl
	add	x1, x20, 232
	add	x0, sp, 88
	mov	x2, 8
	bl	_ZNSo5writeEPKcl
	add	x1, x20, 104
	add	x0, sp, 88
	mov	x2, 4
	bl	_ZNSo5writeEPKcl
	add	x1, x20, 216
	add	x0, sp, 88
	mov	x2, 4
	bl	_ZNSo5writeEPKcl
	add	x1, x20, 56
	add	x0, sp, 88
	mov	x2, 8
	bl	_ZNSo5writeEPKcl
	add	x1, x20, 64
	add	x0, sp, 88
	mov	x2, 8
	bl	_ZNSo5writeEPKcl
	add	x1, x20, 48
	add	x0, sp, 88
	mov	x2, 8
	bl	_ZNSo5writeEPKcl
	add	x1, x20, 88
	add	x0, sp, 88
	mov	x2, 8
	bl	_ZNSo5writeEPKcl
	add	x1, x20, 72
	add	x0, sp, 88
	mov	x2, 8
	bl	_ZNSo5writeEPKcl
	ldr	x1, [x20, 256]
	ldar	x3, [x21]
	ldr	x2, [x20, 24]
	add	x0, sp, 88
	mul	x2, x3, x2
	bl	_ZNSo5writeEPKcl
	mov	x19, 0
	ldar	x0, [x21]
	cmp	x19, x0
	bcs	.L484
	.p2align 3,,7
.L506:
	ldr	x0, [x20, 272]
	mov	w3, 0
	ldr	w0, [x0, x19, lsl 2]
	cmp	w0, 0
	ble	.L485
	ldr	x3, [x20, 32]
	mul	w3, w0, w3
.L485:
	add	x1, sp, 84
	add	x0, sp, 88
	mov	x2, 4
	str	w3, [sp, 84]
	bl	_ZNSo5writeEPKcl
	ldr	w2, [sp, 84]
	cbnz	w2, .L505
	add	x19, x19, 1
.L508:
	ldar	x0, [x21]
	cmp	x19, x0
	bcc	.L506
.L484:
	add	x0, sp, 96
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEE5closeEv
.LEHE25:
	cbz	x0, .L507
.L488:
	adrp	x1, _ZTVSt13basic_filebufIcSt11char_traitsIcEE+16
	add	x1, x1, :lo12:_ZTVSt13basic_filebufIcSt11char_traitsIcEE+16
	add	x0, sp, 96
	stp	x25, x1, [sp, 88]
	str	x24, [sp, 344]
.LEHB26:
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEE5closeEv
.LEHE26:
.L490:
	add	x0, sp, 208
	bl	_ZNSt12__basic_fileIcED1Ev
	adrp	x1, _ZTVSt15basic_streambufIcSt11char_traitsIcEE+16
	add	x1, x1, :lo12:_ZTVSt15basic_streambufIcSt11char_traitsIcEE+16
	add	x0, sp, 152
	str	x1, [sp, 96]
	bl	_ZNSt6localeD1Ev
	ldr	x1, [x22, -24]
	add	x2, sp, 88
	str	x22, [sp, 88]
	add	x0, sp, 344
	str	x26, [x2, x1]
	str	x23, [sp, 344]
	bl	_ZNSt8ios_baseD2Ev
	ldp	x29, x30, [sp]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	add	sp, sp, 608
	.cfi_remember_state
	.cfi_restore 29
	.cfi_restore 30
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L505:
	.cfi_restore_state
	ldr	x1, [x20, 264]
	uxtw	x2, w2
	add	x0, sp, 88
	ldr	x1, [x1, x19, lsl 3]
.LEHB27:
	bl	_ZNSo5writeEPKcl
.LEHE27:
	add	x19, x19, 1
	b	.L508
	.p2align 2,,3
.L504:
	ldr	w1, [x0, 32]
	orr	w1, w1, 4
.LEHB28:
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE5clearESt12_Ios_Iostate
.LEHE28:
	b	.L479
	.p2align 2,,3
.L507:
	ldr	x0, [sp, 88]
	add	x1, sp, 88
	ldr	x0, [x0, -24]
	add	x0, x1, x0
	ldr	w1, [x0, 32]
	orr	w1, w1, 4
.LEHB29:
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE5clearESt12_Ios_Iostate
.LEHE29:
	b	.L488
.L497:
	bl	__cxa_begin_catch
	bl	__cxa_end_catch
	b	.L490
.L493:
	mov	x19, x0
	add	x0, sp, 88
	bl	_ZNSt14basic_ofstreamIcSt11char_traitsIcEED1Ev
	mov	x0, x19
.LEHB30:
	bl	_Unwind_Resume
.L496:
	mov	x19, x0
	add	x0, sp, 96
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEED1Ev
.L482:
	ldr	x0, [x22, -24]
	add	x1, sp, 88
	str	x22, [sp, 88]
	str	x26, [x1, x0]
.L483:
	add	x0, sp, 344
	str	x23, [sp, 344]
	bl	_ZNSt8ios_baseD2Ev
	mov	x0, x19
	bl	_Unwind_Resume
.LEHE30:
.L495:
	mov	x19, x0
	b	.L482
.L494:
	mov	x19, x0
	b	.L483
	.cfi_endproc
.LFE11072:
	.section	.gcc_except_table
	.align	2
.LLSDA11072:
	.byte	0xff
	.byte	0x9b
	.uleb128 .LLSDATT11072-.LLSDATTD11072
.LLSDATTD11072:
	.byte	0x1
	.uleb128 .LLSDACSE11072-.LLSDACSB11072
.LLSDACSB11072:
	.uleb128 .LEHB22-.LFB11072
	.uleb128 .LEHE22-.LEHB22
	.uleb128 .L494-.LFB11072
	.uleb128 0
	.uleb128 .LEHB23-.LFB11072
	.uleb128 .LEHE23-.LEHB23
	.uleb128 .L495-.LFB11072
	.uleb128 0
	.uleb128 .LEHB24-.LFB11072
	.uleb128 .LEHE24-.LEHB24
	.uleb128 .L496-.LFB11072
	.uleb128 0
	.uleb128 .LEHB25-.LFB11072
	.uleb128 .LEHE25-.LEHB25
	.uleb128 .L493-.LFB11072
	.uleb128 0
	.uleb128 .LEHB26-.LFB11072
	.uleb128 .LEHE26-.LEHB26
	.uleb128 .L497-.LFB11072
	.uleb128 0x1
	.uleb128 .LEHB27-.LFB11072
	.uleb128 .LEHE27-.LEHB27
	.uleb128 .L493-.LFB11072
	.uleb128 0
	.uleb128 .LEHB28-.LFB11072
	.uleb128 .LEHE28-.LEHB28
	.uleb128 .L496-.LFB11072
	.uleb128 0
	.uleb128 .LEHB29-.LFB11072
	.uleb128 .LEHE29-.LEHB29
	.uleb128 .L493-.LFB11072
	.uleb128 0
	.uleb128 .LEHB30-.LFB11072
	.uleb128 .LEHE30-.LEHB30
	.uleb128 0
	.uleb128 0
.LLSDACSE11072:
	.byte	0x1
	.byte	0
	.align	2
	.4byte	0

.LLSDATT11072:
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE9saveIndexERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE9saveIndexERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE,comdat
	.size	_ZN7hnswlib15HierarchicalNSWIfE9saveIndexERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE, .-_ZN7hnswlib15HierarchicalNSWIfE9saveIndexERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
	.section	.text._ZNSt8_Rb_treeIjjSt9_IdentityIjESt4lessIjESaIjEE16_M_insert_uniqueIjEESt4pairISt17_Rb_tree_iteratorIjEbEOT_,"axG",@progbits,_ZNSt8_Rb_treeIjjSt9_IdentityIjESt4lessIjESaIjEE16_M_insert_uniqueIjEESt4pairISt17_Rb_tree_iteratorIjEbEOT_,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt8_Rb_treeIjjSt9_IdentityIjESt4lessIjESaIjEE16_M_insert_uniqueIjEESt4pairISt17_Rb_tree_iteratorIjEbEOT_
	.type	_ZNSt8_Rb_treeIjjSt9_IdentityIjESt4lessIjESaIjEE16_M_insert_uniqueIjEESt4pairISt17_Rb_tree_iteratorIjEbEOT_, %function
_ZNSt8_Rb_treeIjjSt9_IdentityIjESt4lessIjESaIjEE16_M_insert_uniqueIjEESt4pairISt17_Rb_tree_iteratorIjEbEOT_:
.LFB11361:
	.cfi_startproc
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -48
	.cfi_offset 20, -40
	ldr	x19, [x0, 16]
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -32
	.cfi_offset 22, -24
	mov	x21, x0
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -16
	.cfi_offset 24, -8
	mov	x22, x1
	add	x23, x0, 8
	cbz	x19, .L510
	ldr	w20, [x1]
	mov	w6, 1
	b	.L511
	.p2align 2,,3
.L525:
	mov	x19, x4
.L511:
	ldp	x4, x5, [x19, 16]
	ldr	w2, [x19, 32]
	cmp	w20, w2
	csel	x4, x4, x5, cc
	csel	w5, w6, wzr, cc
	cbnz	x4, .L525
	cbnz	w5, .L529
	bls	.L519
.L518:
	mov	w24, 1
	cmp	x23, x19
	bne	.L530
.L516:
	mov	x0, 40
	bl	_Znwm
	mov	x20, x0
	ldr	w4, [x22]
	mov	x3, x23
	mov	x2, x19
	mov	w0, w24
	mov	x1, x20
	str	w4, [x20, 32]
	bl	_ZSt29_Rb_tree_insert_and_rebalancebPSt18_Rb_tree_node_baseS0_RS_
	ldr	x2, [x21, 40]
	mov	x3, 1
	mov	x1, 0
	mov	x0, x20
	add	x2, x2, x3
	str	x2, [x21, 40]
	bfi	x1, x3, 0, 8
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L529:
	.cfi_restore_state
	ldr	x0, [x21, 24]
	cmp	x19, x0
	beq	.L518
.L520:
	mov	x0, x19
	bl	_ZSt18_Rb_tree_decrementPSt18_Rb_tree_node_base
	ldr	w1, [x0, 32]
	cmp	w20, w1
	bhi	.L518
	mov	x19, x0
.L519:
	mov	x0, x19
	mov	x1, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 64
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L530:
	.cfi_restore_state
	ldr	w0, [x19, 32]
	cmp	w20, w0
	cset	w24, cc
	b	.L516
	.p2align 2,,3
.L510:
	ldr	x0, [x0, 24]
	mov	x19, x23
	cmp	x23, x0
	beq	.L524
	ldr	w20, [x1]
	b	.L520
.L524:
	mov	w24, 1
	b	.L516
	.cfi_endproc
.LFE11361:
	.size	_ZNSt8_Rb_treeIjjSt9_IdentityIjESt4lessIjESaIjEE16_M_insert_uniqueIjEESt4pairISt17_Rb_tree_iteratorIjEbEOT_, .-_ZNSt8_Rb_treeIjjSt9_IdentityIjESt4lessIjESaIjEE16_M_insert_uniqueIjEESt4pairISt17_Rb_tree_iteratorIjEbEOT_
	.text
	.align	2
	.p2align 4,,11
	.global	_Z11calc_recallSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EESt4lessIS1_EEPimmm
	.type	_Z11calc_recallSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EESt4lessIS1_EEPimmm, %function
_Z11calc_recallSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EESt4lessIS1_EEPimmm:
.LFB10442:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA10442
	stp	x29, x30, [sp, -128]!
	.cfi_def_cfa_offset 128
	.cfi_offset 29, -128
	.cfi_offset 30, -120
	mov	x29, sp
	add	x5, sp, 88
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -112
	.cfi_offset 20, -104
	mov	x19, x0
	stp	x21, x22, [sp, 32]
	mov	x20, x4
	str	wzr, [sp, 88]
	stp	xzr, x5, [sp, 96]
	stp	x5, xzr, [sp, 112]
	str	d8, [sp, 56]
	.cfi_offset 21, -96
	.cfi_offset 22, -88
	.cfi_offset 72, -72
	cbz	x4, .L532
	mul	x3, x3, x2
	str	x23, [sp, 48]
	.cfi_offset 23, -80
	mov	x22, 0
	add	x23, x1, x3, lsl 2
	.p2align 3,,7
.L533:
	ldr	w2, [x23, x22, lsl 2]
	add	x1, sp, 76
	add	x0, sp, 80
	str	w2, [sp, 76]
.LEHB31:
	bl	_ZNSt8_Rb_treeIjjSt9_IdentityIjESt4lessIjESaIjEE16_M_insert_uniqueIjEESt4pairISt17_Rb_tree_iteratorIjEbEOT_
.LEHE31:
	add	x22, x22, 1
	cmp	x20, x22
	bne	.L533
	ldp	x0, x6, [x19]
	ldr	x22, [sp, 96]
	cmp	x0, x6
	beq	.L553
	ldr	x23, [sp, 48]
	.cfi_restore 23
.L551:
	add	x11, sp, 88
	mov	x12, 0
	.p2align 3,,7
.L547:
	ldr	w5, [x0, 4]
	cbz	x22, .L535
	mov	x1, x22
	mov	x7, x11
	.p2align 3,,7
.L536:
	ldr	w2, [x1, 32]
	ldp	x4, x3, [x1, 16]
	cmp	w5, w2
	bls	.L554
	mov	x1, x3
	cbnz	x1, .L536
.L537:
	cmp	x7, x11
	beq	.L535
	ldr	w1, [x7, 32]
	cmp	w5, w1
	cinc	x12, x12, cs
.L535:
	sub	x1, x6, x0
	cmp	x1, 8
	bgt	.L574
.L540:
	sub	x6, x6, #8
	str	x6, [x19, 8]
	cmp	x0, x6
	bne	.L547
	ucvtf	s8, x12
.L534:
	scvtf	s0, x20
	fdiv	s8, s8, s0
	cbz	x22, .L531
.L548:
	ldr	x0, [x22, 24]
	bl	_ZNSt8_Rb_treeIjjSt9_IdentityIjESt4lessIjESaIjEE8_M_eraseEPSt13_Rb_tree_nodeIjE.isra.0
	mov	x0, x22
	ldr	x22, [x22, 16]
	bl	_ZdlPv
	cbnz	x22, .L548
.L531:
	fmov	s0, s8
	ldr	d8, [sp, 56]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 128
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_restore 72
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L554:
	.cfi_restore_state
	mov	x7, x1
	mov	x1, x4
	cbnz	x1, .L536
	b	.L537
	.p2align 2,,3
.L574:
	sub	x1, x6, #8
	ldr	w2, [x6, -8]
	sub	x1, x1, x0
	ldr	s0, [x0]
	ldr	w3, [x6, -4]
	asr	x9, x1, 3
	bfi	x21, x2, 0, 32
	sub	x7, x9, #1
	str	s0, [x6, -8]
	str	w5, [x6, -4]
	bfi	x21, x3, 32, 32
	add	x7, x7, x7, lsr 63
	asr	x7, x7, 1
	cmp	x1, 16
	ble	.L555
	mov	x2, 0
	b	.L545
	.p2align 2,,3
.L557:
	mov	w3, w4
	.p2align 3,,7
.L544:
	lsl	x2, x2, 3
	add	x4, x0, x2
	str	s0, [x0, x2]
	str	w3, [x4, 4]
	cmp	x1, x7
	bge	.L541
.L558:
	mov	x2, x1
.L545:
	add	x3, x2, 1
	lsl	x5, x3, 1
	lsl	x3, x3, 4
	sub	x1, x5, #1
	add	x8, x0, x3
	lsl	x4, x1, 3
	ldr	s1, [x0, x3]
	add	x6, x0, x4
	ldr	s0, [x0, x4]
	fcmpe	s1, s0
	bmi	.L561
	ldr	w3, [x8, 4]
	bgt	.L556
	ldr	w4, [x6, 4]
	cmp	w4, w3
	bhi	.L557
.L556:
	fmov	s0, s1
	lsl	x2, x2, 3
	add	x4, x0, x2
	mov	x1, x5
	str	s0, [x0, x2]
	str	w3, [x4, 4]
	cmp	x1, x7
	blt	.L558
.L541:
	tbnz	x9, 0, .L546
	sub	x9, x9, #2
	add	x9, x9, x9, lsr 63
	cmp	x1, x9, asr 1
	bne	.L546
	lsl	x3, x1, 1
	lsl	x2, x1, 3
	add	x1, x3, 1
	add	x4, x0, x2
	lsl	x3, x1, 3
	add	x5, x0, x3
	ldr	s0, [x0, x3]
	ldr	w3, [x5, 4]
	str	s0, [x0, x2]
	str	w3, [x4, 4]
	.p2align 3,,7
.L546:
	mov	x3, x21
	mov	x2, 0
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldp	x0, x6, [x19]
	ldr	x22, [sp, 96]
	b	.L540
	.p2align 2,,3
.L561:
	ldr	w3, [x6, 4]
	b	.L544
.L555:
	mov	x1, 0
	b	.L541
.L532:
	ldp	x0, x6, [x0]
	mov	x22, 0
	cmp	x6, x0
	bne	.L551
	movi	v8.2s, #0
	fdiv	s8, s8, s8
	b	.L531
.L553:
	.cfi_offset 23, -80
	movi	v8.2s, #0
	ldr	x23, [sp, 48]
	.cfi_remember_state
	.cfi_restore 23
	b	.L534
.L560:
	.cfi_restore_state
	mov	x19, x0
	ldr	x0, [sp, 96]
	bl	_ZNSt8_Rb_treeIjjSt9_IdentityIjESt4lessIjESaIjEE8_M_eraseEPSt13_Rb_tree_nodeIjE.isra.0
	mov	x0, x19
.LEHB32:
	bl	_Unwind_Resume
.LEHE32:
	.cfi_endproc
.LFE10442:
	.section	.gcc_except_table
.LLSDA10442:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE10442-.LLSDACSB10442
.LLSDACSB10442:
	.uleb128 .LEHB31-.LFB10442
	.uleb128 .LEHE31-.LEHB31
	.uleb128 .L560-.LFB10442
	.uleb128 0
	.uleb128 .LEHB32-.LFB10442
	.uleb128 .LEHE32-.LEHB32
	.uleb128 0
	.uleb128 0
.LLSDACSE10442:
	.text
	.size	_Z11calc_recallSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EESt4lessIS1_EEPimmm, .-_Z11calc_recallSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EESt4lessIS1_EEPimmm
	.section	.text._ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEED2Ev,"axG",@progbits,_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEED5Ev,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEED2Ev
	.type	_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEED2Ev, %function
_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEED2Ev:
.LFB11464:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -16
	.cfi_offset 20, -8
	mov	x20, x0
	ldr	x19, [x0, 16]
	cbz	x19, .L576
	.p2align 3,,7
.L577:
	mov	x0, x19
	ldr	x19, [x19]
	bl	_ZdlPv
	cbnz	x19, .L577
.L576:
	ldp	x0, x2, [x20]
	mov	w1, 0
	lsl	x2, x2, 3
	bl	memset
	mov	x1, x20
	ldr	x0, [x1], 48
	stp	xzr, xzr, [x20, 16]
	cmp	x0, x1
	beq	.L575
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	b	_ZdlPv
	.p2align 2,,3
.L575:
	.cfi_restore_state
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE11464:
	.size	_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEED2Ev, .-_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEED2Ev
	.weak	_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEED1Ev
	.set	_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEED1Ev,_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEED2Ev
	.section	.text._ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEED2Ev,"axG",@progbits,_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEED5Ev,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEED2Ev
	.type	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEED2Ev, %function
_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEED2Ev:
.LFB11476:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -16
	.cfi_offset 20, -8
	mov	x20, x0
	ldr	x19, [x0, 16]
	cbz	x19, .L585
	.p2align 3,,7
.L586:
	mov	x0, x19
	ldr	x19, [x19]
	bl	_ZdlPv
	cbnz	x19, .L586
.L585:
	ldp	x0, x2, [x20]
	mov	w1, 0
	lsl	x2, x2, 3
	bl	memset
	mov	x1, x20
	ldr	x0, [x1], 48
	stp	xzr, xzr, [x20, 16]
	cmp	x0, x1
	beq	.L584
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	b	_ZdlPv
	.p2align 2,,3
.L584:
	.cfi_restore_state
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE11476:
	.size	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEED2Ev, .-_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEED2Ev
	.weak	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEED1Ev
	.set	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEED1Ev,_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEED2Ev
	.section	.text._ZN7hnswlib15HierarchicalNSWIfED2Ev,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfED5Ev,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib15HierarchicalNSWIfED2Ev
	.type	_ZN7hnswlib15HierarchicalNSWIfED2Ev, %function
_ZN7hnswlib15HierarchicalNSWIfED2Ev:
.LFB12822:
	.cfi_startproc
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	adrp	x1, _ZTVN7hnswlib15HierarchicalNSWIfEE+16
	add	x1, x1, :lo12:_ZTVN7hnswlib15HierarchicalNSWIfEE+16
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -32
	.cfi_offset 22, -24
	mov	x22, x0
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -48
	.cfi_offset 20, -40
	add	x20, x0, 16
	mov	w19, 0
	ldr	x0, [x0, 256]
	str	x23, [sp, 48]
	.cfi_offset 23, -16
	str	x1, [x22]
	bl	free
	str	xzr, [x22, 256]
	.p2align 3,,7
.L596:
	ldar	x0, [x20]
	uxtw	x1, w19
	add	w19, w19, 1
	cmp	x1, x0
	bcs	.L594
.L652:
	ldr	x0, [x22, 272]
	ldr	w0, [x0, x1, lsl 2]
	cmp	w0, 0
	ble	.L596
	ldr	x0, [x22, 264]
	ldr	x0, [x0, x1, lsl 3]
	bl	free
	ldar	x0, [x20]
	uxtw	x1, w19
	add	w19, w19, 1
	cmp	x1, x0
	bcc	.L652
.L594:
	ldr	x0, [x22, 264]
	bl	free
	str	xzr, [x22, 264]
	stlr	xzr, [x20]
	ldr	x23, [x22, 112]
	str	xzr, [x22, 112]
	cbz	x23, .L597
	add	x20, x23, 48
	add	x19, x23, 16
	b	.L601
	.p2align 2,,3
.L651:
	str	x0, [x23, 16]
	cbnz	x21, .L653
.L601:
	ldp	x3, x21, [x19, 16]
	ldp	x2, x0, [x20]
	ldr	x6, [x20, 24]
	ldr	x4, [x19]
	sub	x1, x6, x21
	sub	x2, x2, x0
	asr	x1, x1, 3
	sub	x5, x3, x4
	sub	x1, x1, #1
	asr	x2, x2, 3
	sub	x3, x3, #8
	add	x0, x4, 8
	add	x1, x2, x1, lsl 6
	add	x1, x1, x5, asr 3
	cbz	x1, .L598
	ldr	x21, [x4]
	cmp	x4, x3
	bne	.L651
	ldr	x0, [x23, 24]
	bl	_ZdlPv
	ldr	x0, [x23, 40]
	add	x1, x0, 8
	ldr	x0, [x0, 8]
	str	x0, [x19, 8]
	str	x1, [x19, 24]
	add	x1, x0, 512
	str	x1, [x19, 16]
	str	x0, [x23, 16]
	cbz	x21, .L601
	.p2align 3,,7
.L653:
	ldr	x0, [x21, 8]
	cbz	x0, .L602
	bl	_ZdaPv
.L602:
	mov	x0, x21
	bl	_ZdlPv
	b	.L601
	.p2align 2,,3
.L598:
	ldr	x0, [x23]
	cbz	x0, .L604
	add	x19, x6, 8
	cmp	x21, x19
	bcs	.L605
	.p2align 3,,7
.L606:
	ldr	x0, [x21], 8
	bl	_ZdlPv
	cmp	x19, x21
	bhi	.L606
	ldr	x0, [x23]
.L605:
	bl	_ZdlPv
.L604:
	mov	x0, x23
	bl	_ZdlPv
.L597:
	add	x0, x22, 512
	bl	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEED1Ev
	add	x0, x22, 368
	bl	_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEED1Ev
	ldr	x0, [x22, 272]
	cbz	x0, .L607
	bl	_ZdlPv
.L607:
	ldr	x0, [x22, 192]
	cbz	x0, .L608
	bl	_ZdlPv
.L608:
	ldr	x0, [x22, 120]
	cbz	x0, .L609
	bl	_ZdlPv
.L609:
	ldr	x22, [x22, 112]
	cbz	x22, .L593
	add	x20, x22, 48
	add	x19, x22, 16
	.p2align 3,,7
.L614:
	ldp	x1, x2, [x20]
	ldr	x21, [x19, 24]
	ldr	x5, [x20, 24]
	sub	x1, x1, x2
	sub	x0, x5, x21
	ldr	x3, [x19]
	asr	x0, x0, 3
	ldr	x2, [x19, 16]
	sub	x0, x0, #1
	asr	x1, x1, 3
	add	x6, x3, 8
	sub	x4, x2, x3
	add	x0, x1, x0, lsl 6
	sub	x2, x2, #8
	add	x0, x0, x4, asr 3
	cbz	x0, .L611
	ldr	x21, [x3]
	cmp	x3, x2
	beq	.L612
	str	x6, [x22, 16]
	cbz	x21, .L614
.L654:
	ldr	x0, [x21, 8]
	cbz	x0, .L615
	bl	_ZdaPv
.L615:
	mov	x0, x21
	bl	_ZdlPv
	b	.L614
	.p2align 2,,3
.L612:
	ldr	x0, [x22, 24]
	bl	_ZdlPv
	ldr	x0, [x22, 40]
	add	x1, x0, 8
	ldr	x0, [x0, 8]
	str	x0, [x19, 8]
	str	x1, [x19, 24]
	add	x1, x0, 512
	str	x1, [x19, 16]
	str	x0, [x22, 16]
	cbz	x21, .L614
	b	.L654
	.p2align 2,,3
.L611:
	ldr	x0, [x22]
	cbz	x0, .L617
	add	x19, x5, 8
	cmp	x21, x19
	bcs	.L618
	.p2align 3,,7
.L619:
	ldr	x0, [x21], 8
	bl	_ZdlPv
	cmp	x19, x21
	bhi	.L619
	ldr	x0, [x22]
.L618:
	bl	_ZdlPv
.L617:
	mov	x0, x22
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 64
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	b	_ZdlPv
	.p2align 2,,3
.L593:
	.cfi_restore_state
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 64
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE12822:
	.size	_ZN7hnswlib15HierarchicalNSWIfED2Ev, .-_ZN7hnswlib15HierarchicalNSWIfED2Ev
	.weak	_ZN7hnswlib15HierarchicalNSWIfED1Ev
	.set	_ZN7hnswlib15HierarchicalNSWIfED1Ev,_ZN7hnswlib15HierarchicalNSWIfED2Ev
	.section	.text._ZN7hnswlib15HierarchicalNSWIfED0Ev,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfED5Ev,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib15HierarchicalNSWIfED0Ev
	.type	_ZN7hnswlib15HierarchicalNSWIfED0Ev, %function
_ZN7hnswlib15HierarchicalNSWIfED0Ev:
.LFB12824:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	mov	x19, x0
	bl	_ZN7hnswlib15HierarchicalNSWIfED1Ev
	mov	x0, x19
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	b	_ZdlPv
	.cfi_endproc
.LFE12824:
	.size	_ZN7hnswlib15HierarchicalNSWIfED0Ev, .-_ZN7hnswlib15HierarchicalNSWIfED0Ev
	.section	.rodata._Z8LoadDataIiEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_.str1.8,"aMS",@progbits,1
	.align	3
.LC38:
	.string	"load data "
	.align	3
.LC39:
	.string	"dimension: "
	.align	3
.LC40:
	.string	"  number:"
	.align	3
.LC41:
	.string	"  size_per_element:"
	.section	.text._Z8LoadDataIiEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_,"axG",@progbits,_Z8LoadDataIiEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_,comdat
	.align	2
	.p2align 4,,11
	.weak	_Z8LoadDataIiEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_
	.type	_Z8LoadDataIiEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_, %function
_Z8LoadDataIiEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_:
.LFB11074:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA11074
	sub	sp, sp, #624
	.cfi_def_cfa_offset 624
	stp	x29, x30, [sp]
	.cfi_offset 29, -624
	.cfi_offset 30, -616
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -608
	.cfi_offset 20, -600
	mov	x20, x1
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -592
	.cfi_offset 22, -584
	mov	x21, x2
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -576
	.cfi_offset 24, -568
	mov	x24, x0
	add	x0, sp, 360
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -560
	.cfi_offset 26, -552
	adrp	x25, _ZTVSt9basic_iosIcSt11char_traitsIcEE+16
	add	x25, x25, :lo12:_ZTVSt9basic_iosIcSt11char_traitsIcEE+16
	stp	x27, x28, [sp, 80]
	.cfi_offset 27, -544
	.cfi_offset 28, -536
	bl	_ZNSt8ios_baseC2Ev
	adrp	x0, _ZTTSt14basic_ifstreamIcSt11char_traitsIcEE
	add	x0, x0, :lo12:_ZTTSt14basic_ifstreamIcSt11char_traitsIcEE
	strh	wzr, [sp, 584]
	add	x3, sp, 592
	mov	x1, 0
	ldp	x23, x28, [x0, 8]
	add	x0, sp, 96
	ldr	x2, [x23, -24]
	stp	xzr, xzr, [x3]
	stp	xzr, xzr, [x3, 16]
	str	x23, [sp, 96]
	str	x25, [sp, 360]
	str	xzr, [sp, 576]
	str	x28, [x0, x2]
	add	x2, sp, 96
	str	xzr, [sp, 104]
	ldr	x0, [x23, -24]
	add	x0, x2, x0
.LEHB33:
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE4initEPSt15basic_streambufIcS1_E
.LEHE33:
	adrp	x27, _ZTVSt14basic_ifstreamIcSt11char_traitsIcEE+24
	adrp	x26, _ZTVSt14basic_ifstreamIcSt11char_traitsIcEE+64
	add	x27, x27, :lo12:_ZTVSt14basic_ifstreamIcSt11char_traitsIcEE+24
	add	x26, x26, :lo12:_ZTVSt14basic_ifstreamIcSt11char_traitsIcEE+64
	add	x0, sp, 112
	str	x27, [sp, 96]
	str	x26, [sp, 360]
.LEHB34:
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEEC1Ev
.LEHE34:
	add	x0, sp, 96
	add	x1, sp, 112
	add	x0, x0, 264
.LEHB35:
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE4initEPSt15basic_streambufIcS1_E
.LEHE35:
	ldr	x1, [x24]
	add	x0, sp, 112
	mov	w2, 12
.LEHB36:
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEE4openEPKcSt13_Ios_Openmode
	mov	x2, x0
	ldr	x0, [sp, 96]
	ldr	x1, [x0, -24]
	add	x0, sp, 96
	add	x0, x0, x1
	cbz	x2, .L684
	mov	w1, 0
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE5clearESt12_Ios_Iostate
.L663:
	mov	x1, x20
	add	x0, sp, 96
	mov	x2, 4
	bl	_ZNSi4readEPcl
	mov	x1, x21
	add	x0, sp, 96
	mov	x2, 4
	bl	_ZNSi4readEPcl
	ldr	x0, [x20]
	mov	x1, 2305843009213693950
	ldr	x2, [x21]
	mul	x0, x0, x2
	cmp	x0, x1
	bhi	.L664
	lsl	x0, x0, 2
	bl	_Znam
	ldr	x1, [x20]
	mov	x22, x0
	mov	x19, 0
	cbz	x1, .L668
	.p2align 3,,7
.L666:
	ldr	x2, [x21]
	add	x0, sp, 96
	lsl	x2, x2, 2
	madd	x1, x2, x19, x22
	bl	_ZNSi4readEPcl
	ldr	x0, [x20]
	add	x19, x19, 1
	cmp	x0, x19
	bhi	.L666
.L668:
	add	x0, sp, 112
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEE5closeEv
	cbz	x0, .L685
.L669:
	adrp	x19, _ZSt4cerr
	add	x19, x19, :lo12:_ZSt4cerr
	adrp	x1, .LC38
	mov	x0, x19
	add	x1, x1, :lo12:.LC38
	mov	x2, 10
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	ldp	x1, x2, [x24]
	mov	x0, x19
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	adrp	x24, .LC10
	add	x24, x24, :lo12:.LC10
	mov	x1, x24
	mov	x2, 1
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	adrp	x1, .LC39
	mov	x0, x19
	add	x1, x1, :lo12:.LC39
	mov	x2, 11
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	ldr	x1, [x21]
	mov	x0, x19
	bl	_ZNSo9_M_insertImEERSoT_
	adrp	x1, .LC40
	mov	x19, x0
	add	x1, x1, :lo12:.LC40
	mov	x2, 9
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	ldr	x1, [x20]
	mov	x0, x19
	bl	_ZNSo9_M_insertImEERSoT_
	adrp	x1, .LC41
	mov	x19, x0
	add	x1, x1, :lo12:.LC41
	mov	x2, 19
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	mov	x0, x19
	mov	x1, 4
	bl	_ZNSo9_M_insertImEERSoT_
	mov	x1, x24
	mov	x2, 1
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.LEHE36:
	adrp	x1, _ZTVSt13basic_filebufIcSt11char_traitsIcEE+16
	add	x1, x1, :lo12:_ZTVSt13basic_filebufIcSt11char_traitsIcEE+16
	add	x0, sp, 112
	str	x27, [sp, 96]
	str	x1, [sp, 112]
	str	x26, [sp, 360]
.LEHB37:
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEE5closeEv
.LEHE37:
.L671:
	add	x0, sp, 224
	bl	_ZNSt12__basic_fileIcED1Ev
	adrp	x1, _ZTVSt15basic_streambufIcSt11char_traitsIcEE+16
	add	x1, x1, :lo12:_ZTVSt15basic_streambufIcSt11char_traitsIcEE+16
	add	x0, sp, 168
	str	x1, [sp, 112]
	bl	_ZNSt6localeD1Ev
	ldr	x1, [x23, -24]
	add	x2, sp, 96
	str	x23, [sp, 96]
	add	x0, sp, 360
	str	x28, [x2, x1]
	str	xzr, [sp, 104]
	str	x25, [sp, 360]
	bl	_ZNSt8ios_baseD2Ev
	mov	x0, x22
	ldp	x29, x30, [sp]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	add	sp, sp, 624
	.cfi_remember_state
	.cfi_restore 29
	.cfi_restore 30
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L684:
	.cfi_restore_state
	ldr	w1, [x0, 32]
	orr	w1, w1, 4
.LEHB38:
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE5clearESt12_Ios_Iostate
	b	.L663
	.p2align 2,,3
.L685:
	ldr	x0, [sp, 96]
	add	x1, sp, 96
	ldr	x0, [x0, -24]
	add	x0, x1, x0
	ldr	w1, [x0, 32]
	orr	w1, w1, 4
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE5clearESt12_Ios_Iostate
.LEHE38:
	b	.L669
.L678:
	bl	__cxa_begin_catch
	bl	__cxa_end_catch
	b	.L671
.L677:
	mov	x19, x0
	add	x0, sp, 112
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEED1Ev
.L660:
	ldr	x0, [x23, -24]
	add	x1, sp, 96
	str	x23, [sp, 96]
	str	x28, [x1, x0]
	str	xzr, [sp, 104]
.L661:
	add	x0, sp, 360
	str	x25, [sp, 360]
	bl	_ZNSt8ios_baseD2Ev
	mov	x0, x19
.LEHB39:
	bl	_Unwind_Resume
.LEHE39:
.L676:
	mov	x19, x0
	b	.L660
.L664:
.LEHB40:
	bl	__cxa_throw_bad_array_new_length
.LEHE40:
.L675:
	mov	x19, x0
	b	.L661
.L674:
	mov	x19, x0
	add	x0, sp, 96
	bl	_ZNSt14basic_ifstreamIcSt11char_traitsIcEED1Ev
	mov	x0, x19
.LEHB41:
	bl	_Unwind_Resume
.LEHE41:
	.cfi_endproc
.LFE11074:
	.section	.gcc_except_table
	.align	2
.LLSDA11074:
	.byte	0xff
	.byte	0x9b
	.uleb128 .LLSDATT11074-.LLSDATTD11074
.LLSDATTD11074:
	.byte	0x1
	.uleb128 .LLSDACSE11074-.LLSDACSB11074
.LLSDACSB11074:
	.uleb128 .LEHB33-.LFB11074
	.uleb128 .LEHE33-.LEHB33
	.uleb128 .L675-.LFB11074
	.uleb128 0
	.uleb128 .LEHB34-.LFB11074
	.uleb128 .LEHE34-.LEHB34
	.uleb128 .L676-.LFB11074
	.uleb128 0
	.uleb128 .LEHB35-.LFB11074
	.uleb128 .LEHE35-.LEHB35
	.uleb128 .L677-.LFB11074
	.uleb128 0
	.uleb128 .LEHB36-.LFB11074
	.uleb128 .LEHE36-.LEHB36
	.uleb128 .L674-.LFB11074
	.uleb128 0
	.uleb128 .LEHB37-.LFB11074
	.uleb128 .LEHE37-.LEHB37
	.uleb128 .L678-.LFB11074
	.uleb128 0x1
	.uleb128 .LEHB38-.LFB11074
	.uleb128 .LEHE38-.LEHB38
	.uleb128 .L674-.LFB11074
	.uleb128 0
	.uleb128 .LEHB39-.LFB11074
	.uleb128 .LEHE39-.LEHB39
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB40-.LFB11074
	.uleb128 .LEHE40-.LEHB40
	.uleb128 .L674-.LFB11074
	.uleb128 0
	.uleb128 .LEHB41-.LFB11074
	.uleb128 .LEHE41-.LEHB41
	.uleb128 0
	.uleb128 0
.LLSDACSE11074:
	.byte	0x1
	.byte	0
	.align	2
	.4byte	0

.LLSDATT11074:
	.section	.text._Z8LoadDataIiEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_,"axG",@progbits,_Z8LoadDataIiEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_,comdat
	.size	_Z8LoadDataIiEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_, .-_Z8LoadDataIiEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_
	.section	.text._Z8LoadDataIfEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_,"axG",@progbits,_Z8LoadDataIfEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_,comdat
	.align	2
	.p2align 4,,11
	.weak	_Z8LoadDataIfEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_
	.type	_Z8LoadDataIfEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_, %function
_Z8LoadDataIfEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_:
.LFB11073:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA11073
	sub	sp, sp, #624
	.cfi_def_cfa_offset 624
	stp	x29, x30, [sp]
	.cfi_offset 29, -624
	.cfi_offset 30, -616
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -608
	.cfi_offset 20, -600
	mov	x20, x1
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -592
	.cfi_offset 22, -584
	mov	x21, x2
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -576
	.cfi_offset 24, -568
	mov	x24, x0
	add	x0, sp, 360
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -560
	.cfi_offset 26, -552
	adrp	x25, _ZTVSt9basic_iosIcSt11char_traitsIcEE+16
	add	x25, x25, :lo12:_ZTVSt9basic_iosIcSt11char_traitsIcEE+16
	stp	x27, x28, [sp, 80]
	.cfi_offset 27, -544
	.cfi_offset 28, -536
	bl	_ZNSt8ios_baseC2Ev
	adrp	x0, _ZTTSt14basic_ifstreamIcSt11char_traitsIcEE
	add	x0, x0, :lo12:_ZTTSt14basic_ifstreamIcSt11char_traitsIcEE
	strh	wzr, [sp, 584]
	add	x3, sp, 592
	mov	x1, 0
	ldp	x23, x28, [x0, 8]
	add	x0, sp, 96
	ldr	x2, [x23, -24]
	stp	xzr, xzr, [x3]
	stp	xzr, xzr, [x3, 16]
	str	x23, [sp, 96]
	str	x25, [sp, 360]
	str	xzr, [sp, 576]
	str	x28, [x0, x2]
	add	x2, sp, 96
	str	xzr, [sp, 104]
	ldr	x0, [x23, -24]
	add	x0, x2, x0
.LEHB42:
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE4initEPSt15basic_streambufIcS1_E
.LEHE42:
	adrp	x27, _ZTVSt14basic_ifstreamIcSt11char_traitsIcEE+24
	adrp	x26, _ZTVSt14basic_ifstreamIcSt11char_traitsIcEE+64
	add	x27, x27, :lo12:_ZTVSt14basic_ifstreamIcSt11char_traitsIcEE+24
	add	x26, x26, :lo12:_ZTVSt14basic_ifstreamIcSt11char_traitsIcEE+64
	add	x0, sp, 112
	str	x27, [sp, 96]
	str	x26, [sp, 360]
.LEHB43:
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEEC1Ev
.LEHE43:
	add	x0, sp, 96
	add	x1, sp, 112
	add	x0, x0, 264
.LEHB44:
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE4initEPSt15basic_streambufIcS1_E
.LEHE44:
	ldr	x1, [x24]
	add	x0, sp, 112
	mov	w2, 12
.LEHB45:
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEE4openEPKcSt13_Ios_Openmode
	mov	x2, x0
	ldr	x0, [sp, 96]
	ldr	x1, [x0, -24]
	add	x0, sp, 96
	add	x0, x0, x1
	cbz	x2, .L713
	mov	w1, 0
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE5clearESt12_Ios_Iostate
.L692:
	mov	x1, x20
	add	x0, sp, 96
	mov	x2, 4
	bl	_ZNSi4readEPcl
	mov	x1, x21
	add	x0, sp, 96
	mov	x2, 4
	bl	_ZNSi4readEPcl
	ldr	x0, [x20]
	mov	x1, 2305843009213693950
	ldr	x2, [x21]
	mul	x0, x0, x2
	cmp	x0, x1
	bhi	.L693
	lsl	x0, x0, 2
	bl	_Znam
	ldr	x1, [x20]
	mov	x22, x0
	mov	x19, 0
	cbz	x1, .L697
	.p2align 3,,7
.L695:
	ldr	x2, [x21]
	add	x0, sp, 96
	lsl	x2, x2, 2
	madd	x1, x2, x19, x22
	bl	_ZNSi4readEPcl
	ldr	x0, [x20]
	add	x19, x19, 1
	cmp	x0, x19
	bhi	.L695
.L697:
	add	x0, sp, 112
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEE5closeEv
	cbz	x0, .L714
.L698:
	adrp	x19, _ZSt4cerr
	add	x19, x19, :lo12:_ZSt4cerr
	adrp	x1, .LC38
	mov	x0, x19
	add	x1, x1, :lo12:.LC38
	mov	x2, 10
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	ldp	x1, x2, [x24]
	mov	x0, x19
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	adrp	x24, .LC10
	add	x24, x24, :lo12:.LC10
	mov	x1, x24
	mov	x2, 1
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	adrp	x1, .LC39
	mov	x0, x19
	add	x1, x1, :lo12:.LC39
	mov	x2, 11
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	ldr	x1, [x21]
	mov	x0, x19
	bl	_ZNSo9_M_insertImEERSoT_
	adrp	x1, .LC40
	mov	x19, x0
	add	x1, x1, :lo12:.LC40
	mov	x2, 9
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	ldr	x1, [x20]
	mov	x0, x19
	bl	_ZNSo9_M_insertImEERSoT_
	adrp	x1, .LC41
	mov	x19, x0
	add	x1, x1, :lo12:.LC41
	mov	x2, 19
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	mov	x0, x19
	mov	x1, 4
	bl	_ZNSo9_M_insertImEERSoT_
	mov	x1, x24
	mov	x2, 1
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.LEHE45:
	adrp	x1, _ZTVSt13basic_filebufIcSt11char_traitsIcEE+16
	add	x1, x1, :lo12:_ZTVSt13basic_filebufIcSt11char_traitsIcEE+16
	add	x0, sp, 112
	str	x27, [sp, 96]
	str	x1, [sp, 112]
	str	x26, [sp, 360]
.LEHB46:
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEE5closeEv
.LEHE46:
.L700:
	add	x0, sp, 224
	bl	_ZNSt12__basic_fileIcED1Ev
	adrp	x1, _ZTVSt15basic_streambufIcSt11char_traitsIcEE+16
	add	x1, x1, :lo12:_ZTVSt15basic_streambufIcSt11char_traitsIcEE+16
	add	x0, sp, 168
	str	x1, [sp, 112]
	bl	_ZNSt6localeD1Ev
	ldr	x1, [x23, -24]
	add	x2, sp, 96
	str	x23, [sp, 96]
	add	x0, sp, 360
	str	x28, [x2, x1]
	str	xzr, [sp, 104]
	str	x25, [sp, 360]
	bl	_ZNSt8ios_baseD2Ev
	mov	x0, x22
	ldp	x29, x30, [sp]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	add	sp, sp, 624
	.cfi_remember_state
	.cfi_restore 29
	.cfi_restore 30
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L713:
	.cfi_restore_state
	ldr	w1, [x0, 32]
	orr	w1, w1, 4
.LEHB47:
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE5clearESt12_Ios_Iostate
	b	.L692
	.p2align 2,,3
.L714:
	ldr	x0, [sp, 96]
	add	x1, sp, 96
	ldr	x0, [x0, -24]
	add	x0, x1, x0
	ldr	w1, [x0, 32]
	orr	w1, w1, 4
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE5clearESt12_Ios_Iostate
.LEHE47:
	b	.L698
.L707:
	bl	__cxa_begin_catch
	bl	__cxa_end_catch
	b	.L700
.L706:
	mov	x19, x0
	add	x0, sp, 112
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEED1Ev
.L689:
	ldr	x0, [x23, -24]
	add	x1, sp, 96
	str	x23, [sp, 96]
	str	x28, [x1, x0]
	str	xzr, [sp, 104]
.L690:
	add	x0, sp, 360
	str	x25, [sp, 360]
	bl	_ZNSt8ios_baseD2Ev
	mov	x0, x19
.LEHB48:
	bl	_Unwind_Resume
.LEHE48:
.L705:
	mov	x19, x0
	b	.L689
.L693:
.LEHB49:
	bl	__cxa_throw_bad_array_new_length
.LEHE49:
.L704:
	mov	x19, x0
	b	.L690
.L703:
	mov	x19, x0
	add	x0, sp, 96
	bl	_ZNSt14basic_ifstreamIcSt11char_traitsIcEED1Ev
	mov	x0, x19
.LEHB50:
	bl	_Unwind_Resume
.LEHE50:
	.cfi_endproc
.LFE11073:
	.section	.gcc_except_table
	.align	2
.LLSDA11073:
	.byte	0xff
	.byte	0x9b
	.uleb128 .LLSDATT11073-.LLSDATTD11073
.LLSDATTD11073:
	.byte	0x1
	.uleb128 .LLSDACSE11073-.LLSDACSB11073
.LLSDACSB11073:
	.uleb128 .LEHB42-.LFB11073
	.uleb128 .LEHE42-.LEHB42
	.uleb128 .L704-.LFB11073
	.uleb128 0
	.uleb128 .LEHB43-.LFB11073
	.uleb128 .LEHE43-.LEHB43
	.uleb128 .L705-.LFB11073
	.uleb128 0
	.uleb128 .LEHB44-.LFB11073
	.uleb128 .LEHE44-.LEHB44
	.uleb128 .L706-.LFB11073
	.uleb128 0
	.uleb128 .LEHB45-.LFB11073
	.uleb128 .LEHE45-.LEHB45
	.uleb128 .L703-.LFB11073
	.uleb128 0
	.uleb128 .LEHB46-.LFB11073
	.uleb128 .LEHE46-.LEHB46
	.uleb128 .L707-.LFB11073
	.uleb128 0x1
	.uleb128 .LEHB47-.LFB11073
	.uleb128 .LEHE47-.LEHB47
	.uleb128 .L703-.LFB11073
	.uleb128 0
	.uleb128 .LEHB48-.LFB11073
	.uleb128 .LEHE48-.LEHB48
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB49-.LFB11073
	.uleb128 .LEHE49-.LEHB49
	.uleb128 .L703-.LFB11073
	.uleb128 0
	.uleb128 .LEHB50-.LFB11073
	.uleb128 .LEHE50-.LEHB50
	.uleb128 0
	.uleb128 0
.LLSDACSE11073:
	.byte	0x1
	.byte	0
	.align	2
	.4byte	0

.LLSDATT11073:
	.section	.text._Z8LoadDataIfEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_,"axG",@progbits,_Z8LoadDataIfEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_,comdat
	.size	_Z8LoadDataIfEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_, .-_Z8LoadDataIfEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_
	.section	.rodata._ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_.str1.8,"aMS",@progbits,1
	.align	3
.LC42:
	.string	"vector::_M_realloc_insert"
	.section	.text._ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_,"axG",@progbits,_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.type	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_, %function
_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_:
.LFB11653:
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	ldp	x24, x23, [x0]
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	mov	x20, x0
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	sub	x0, x23, x24
	str	x27, [sp, 80]
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	.cfi_offset 27, -16
	mov	x27, x2
	asr	x0, x0, 3
	mov	x2, 1152921504606846975
	cmp	x0, x2
	beq	.L733
	cmp	x0, 0
	mov	x19, x1
	sub	x26, x1, x24
	csinc	x1, x0, xzr, ne
	adds	x1, x1, x0
	bcs	.L726
	cbnz	x1, .L720
	mov	x25, 8
	mov	x22, 0
	mov	x21, 0
.L725:
	ldr	x0, [x27]
	str	x0, [x21, x26]
	cmp	x19, x24
	beq	.L721
	mov	x4, x21
	mov	x3, x24
	.p2align 3,,7
.L722:
	ldr	x5, [x3], 8
	str	x5, [x4], 8
	cmp	x3, x19
	bne	.L722
	add	x26, x26, 8
	add	x25, x21, x26
.L721:
	cmp	x19, x23
	beq	.L723
	sub	x2, x23, x19
	mov	x0, x25
	mov	x1, x19
	add	x25, x25, x2
	bl	memcpy
.L723:
	cbz	x24, .L724
	mov	x0, x24
	bl	_ZdlPv
.L724:
	ldp	x23, x24, [sp, 48]
	ldr	x27, [sp, 80]
	stp	x21, x25, [x20]
	str	x22, [x20, 16]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L726:
	.cfi_restore_state
	mov	x22, 9223372036854775800
.L719:
	mov	x0, x22
	bl	_Znwm
	mov	x21, x0
	add	x22, x0, x22
	add	x25, x0, 8
	b	.L725
.L720:
	cmp	x1, x2
	csel	x1, x1, x2, ls
	lsl	x22, x1, 3
	b	.L719
.L733:
	adrp	x0, .LC42
	add	x0, x0, :lo12:.LC42
	bl	_ZSt20__throw_length_errorPKc
	.cfi_endproc
.LFE11653:
	.size	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_, .-_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.text
	.align	2
	.p2align 4,,11
	.global	_Z11flat_searchPfS_mmm
	.type	_Z11flat_searchPfS_mmm, %function
_Z11flat_searchPfS_mmm:
.LFB6074:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA6074
	stp	x29, x30, [sp, -112]!
	.cfi_def_cfa_offset 112
	.cfi_offset 29, -112
	.cfi_offset 30, -104
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -80
	.cfi_offset 22, -72
	mov	x22, x8
	stp	xzr, xzr, [x8]
	str	xzr, [x8, 16]
	cbz	x2, .L734
	stp	x19, x20, [sp, 16]
	.cfi_offset 20, -88
	.cfi_offset 19, -96
	mov	x21, x1
	mov	x19, x0
	stp	x23, x24, [sp, 48]
	.cfi_offset 24, -56
	.cfi_offset 23, -64
	lsl	x20, x3, 2
	mov	x24, x2
	stp	x25, x26, [sp, 64]
	.cfi_offset 26, -40
	.cfi_offset 25, -48
	mov	x23, 0
	mov	x25, x3
	str	x27, [sp, 80]
	.cfi_offset 27, -32
	mov	x26, x4
	str	d8, [sp, 88]
	.cfi_offset 72, -24
	mov	x1, 0
	mov	x0, 0
	fmov	s8, 1.0e+0
	cbz	x25, .L755
	.p2align 3,,7
.L774:
	movi	v0.2s, #0
	mov	x5, 0
	.p2align 3,,7
.L737:
	ldr	s2, [x19, x5]
	ldr	s1, [x21, x5]
	add	x5, x5, 4
	fmadd	s0, s2, s1, s0
	cmp	x20, x5
	bne	.L737
	sub	x2, x1, x0
	fsub	s0, s8, s0
	cmp	x26, x2, asr 3
	bhi	.L773
.L738:
	ldr	s1, [x0]
	fcmpe	s1, s0
	bgt	.L761
.L741:
	add	x23, x23, 1
	add	x19, x19, x20
	cmp	x24, x23
	beq	.L772
.L775:
	ldp	x0, x1, [x22]
	cbnz	x25, .L774
.L755:
	sub	x2, x1, x0
	fmov	s0, 1.0e+0
	cmp	x26, x2, asr 3
	bls	.L738
	.p2align 3,,7
.L773:
	ldr	x2, [x22, 16]
	str	s0, [sp, 104]
	str	w23, [sp, 108]
	cmp	x2, x1
	beq	.L739
	ldr	x2, [sp, 104]
	str	x2, [x1], 8
	str	x1, [x22, 8]
.L740:
	ldr	x3, [x1, -8]
	sub	x2, x1, x0
	add	x23, x23, 1
	add	x19, x19, x20
	asr	x1, x2, 3
	mov	x2, 0
	sub	x1, x1, #1
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	cmp	x24, x23
	bne	.L775
.L772:
	ldp	x19, x20, [sp, 16]
	.cfi_restore 20
	.cfi_restore 19
	ldp	x23, x24, [sp, 48]
	.cfi_restore 24
	.cfi_restore 23
	ldp	x25, x26, [sp, 64]
	.cfi_restore 26
	.cfi_restore 25
	ldr	x27, [sp, 80]
	.cfi_restore 27
	ldr	d8, [sp, 88]
	.cfi_restore 72
.L734:
	mov	x0, x22
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 112
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 22
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L761:
	.cfi_def_cfa_offset 112
	.cfi_offset 19, -96
	.cfi_offset 20, -88
	.cfi_offset 21, -80
	.cfi_offset 22, -72
	.cfi_offset 23, -64
	.cfi_offset 24, -56
	.cfi_offset 25, -48
	.cfi_offset 26, -40
	.cfi_offset 27, -32
	.cfi_offset 29, -112
	.cfi_offset 30, -104
	.cfi_offset 72, -24
	ldr	x2, [x22, 16]
	str	s0, [sp, 104]
	str	w23, [sp, 108]
	cmp	x2, x1
	beq	.L743
	ldr	x2, [sp, 104]
	str	x2, [x1], 8
	str	x1, [x22, 8]
.L744:
	ldr	x3, [x1, -8]
	sub	x2, x1, x0
	asr	x1, x2, 3
	mov	x2, 0
	sub	x1, x1, #1
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldp	x0, x1, [x22]
	sub	x2, x1, x0
	cmp	x2, 8
	bgt	.L776
.L745:
	sub	x1, x1, #8
	str	x1, [x22, 8]
	b	.L741
.L776:
	sub	x3, x1, #8
	ldr	w4, [x1, -8]
	sub	x3, x3, x0
	ldr	s0, [x0]
	ldr	w5, [x1, -4]
	asr	x9, x3, 3
	ldr	w6, [x0, 4]
	sub	x2, x9, #1
	bfi	x27, x4, 0, 32
	str	s0, [x1, -8]
	add	x2, x2, x2, lsr 63
	str	w6, [x1, -4]
	bfi	x27, x5, 32, 32
	asr	x6, x2, 1
	cmp	x3, 16
	ble	.L756
	mov	x2, 0
	b	.L750
.L758:
	mov	w3, w4
.L749:
	lsl	x2, x2, 3
	add	x4, x0, x2
	str	s0, [x0, x2]
	str	w3, [x4, 4]
	cmp	x1, x6
	bge	.L746
.L759:
	mov	x2, x1
.L750:
	add	x3, x2, 1
	lsl	x5, x3, 1
	lsl	x3, x3, 4
	sub	x1, x5, #1
	add	x8, x0, x3
	lsl	x4, x1, 3
	ldr	s1, [x0, x3]
	add	x7, x0, x4
	ldr	s0, [x0, x4]
	fcmpe	s1, s0
	bmi	.L762
	ldr	w3, [x8, 4]
	bgt	.L757
	ldr	w4, [x7, 4]
	cmp	w4, w3
	bhi	.L758
.L757:
	fmov	s0, s1
	lsl	x2, x2, 3
	add	x4, x0, x2
	mov	x1, x5
	str	s0, [x0, x2]
	str	w3, [x4, 4]
	cmp	x1, x6
	blt	.L759
.L746:
	tbnz	x9, 0, .L751
.L778:
	sub	x9, x9, #2
	add	x9, x9, x9, lsr 63
	cmp	x1, x9, asr 1
	beq	.L777
.L751:
	mov	x3, x27
	mov	x2, 0
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldr	x1, [x22, 8]
	b	.L745
	.p2align 2,,3
.L762:
	ldr	w3, [x7, 4]
	b	.L749
.L739:
	add	x2, sp, 104
	mov	x0, x22
.LEHB51:
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	ldp	x0, x1, [x22]
	b	.L740
.L743:
	add	x2, sp, 104
	mov	x0, x22
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE51:
	ldp	x0, x1, [x22]
	b	.L744
.L777:
	lsl	x3, x1, 1
	lsl	x2, x1, 3
	add	x1, x3, 1
	add	x4, x0, x2
	lsl	x3, x1, 3
	add	x5, x0, x3
	ldr	s0, [x0, x3]
	ldr	w3, [x5, 4]
	str	s0, [x0, x2]
	mov	x2, 0
	str	w3, [x4, 4]
	mov	x3, x27
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldr	x1, [x22, 8]
	b	.L745
.L756:
	mov	x1, 0
	tbnz	x9, 0, .L751
	b	.L778
.L760:
	ldr	x1, [x22]
	mov	x19, x0
	cbz	x1, .L754
	mov	x0, x1
	bl	_ZdlPv
.L754:
	mov	x0, x19
.LEHB52:
	bl	_Unwind_Resume
.LEHE52:
	.cfi_endproc
.LFE6074:
	.section	.gcc_except_table
.LLSDA6074:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE6074-.LLSDACSB6074
.LLSDACSB6074:
	.uleb128 .LEHB51-.LFB6074
	.uleb128 .LEHE51-.LEHB51
	.uleb128 .L760-.LFB6074
	.uleb128 0
	.uleb128 .LEHB52-.LFB6074
	.uleb128 .LEHE52-.LEHB52
	.uleb128 0
	.uleb128 0
.LLSDACSE6074:
	.text
	.size	_Z11flat_searchPfS_mmm, .-_Z11flat_searchPfS_mmm
	.section	.text._ZN3ann23sq8_search_rerank_timedERKNS_8SQ8IndexEPKfS4_mmPNS_11QuantTimingE,"axG",@progbits,_ZN3ann23sq8_search_rerank_timedERKNS_8SQ8IndexEPKfS4_mmPNS_11QuantTimingE,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN3ann23sq8_search_rerank_timedERKNS_8SQ8IndexEPKfS4_mmPNS_11QuantTimingE
	.type	_ZN3ann23sq8_search_rerank_timedERKNS_8SQ8IndexEPKfS4_mmPNS_11QuantTimingE, %function
_ZN3ann23sq8_search_rerank_timedERKNS_8SQ8IndexEPKfS4_mmPNS_11QuantTimingE:
.LFB10423:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA10423
	stp	x29, x30, [sp, -208]!
	.cfi_def_cfa_offset 208
	.cfi_offset 29, -208
	.cfi_offset 30, -200
	mov	x29, sp
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -160
	.cfi_offset 24, -152
	mov	x23, x0
	ldr	x24, [x0]
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -192
	.cfi_offset 20, -184
	mov	x19, x2
	cmp	x24, x3
	stp	x21, x22, [sp, 32]
	csel	x24, x24, x3, ls
	.cfi_offset 21, -176
	.cfi_offset 22, -168
	mov	x21, x8
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -144
	.cfi_offset 26, -136
	mov	x25, x1
	mov	x26, x4
	stp	x27, x28, [sp, 80]
	str	d8, [sp, 96]
	.cfi_offset 27, -128
	.cfi_offset 28, -120
	.cfi_offset 72, -112
	str	x5, [sp, 136]
	bl	_ZNSt6chrono3_V212system_clock3nowEv
	ldr	x4, [x23, 8]
	str	x0, [sp, 128]
	mov	x1, 2305843009213693951
	lsl	x0, x4, 8
	cmp	x0, x1
	bhi	.L894
	mov	x20, 0
	cbz	x0, .L781
	lsl	x22, x4, 10
	mov	x0, x22
.LEHB53:
	bl	_Znwm
.LEHE53:
	add	x1, x0, x22
	mov	x20, x0
	cmp	x0, x1
	beq	.L893
	mov	x2, x22
	mov	w1, 0
	bl	memset
.L893:
	ldr	x4, [x23, 8]
.L781:
	cbz	x4, .L787
	ldr	x5, [x23, 40]
	mov	x1, x20
	ldr	x3, [x23, 64]
	mov	x2, 0
.L788:
	ldr	s3, [x19, x2, lsl 2]
	mov	x0, 0
	ldr	s2, [x5, x2, lsl 2]
	ldr	s1, [x3, x2, lsl 2]
	.p2align 3,,7
.L786:
	scvtf	s0, w0
	fmadd	s0, s0, s1, s2
	fmul	s0, s0, s3
	str	s0, [x1, x0, lsl 2]
	add	x0, x0, 1
	cmp	x0, 256
	bne	.L786
	add	x2, x2, 1
	add	x1, x1, 1024
	cmp	x2, x4
	bne	.L788
.L787:
	ldr	x6, [x23]
	stp	xzr, xzr, [sp, 176]
	str	xzr, [sp, 192]
	cbz	x6, .L784
	mov	x22, 0
	add	x27, x23, 16
	mov	x0, 0
	mov	x1, 0
	mul	x2, x22, x4
	fmov	s8, 1.0e+0
	ldr	x5, [x27]
	cbz	x4, .L841
.L896:
	movi	v0.2s, #0
	add	x5, x5, x2
	mov	x2, 0
	.p2align 3,,7
.L790:
	ldrb	w3, [x5, x2]
	add	x3, x3, x2, lsl 8
	add	x2, x2, 1
	ldr	s1, [x20, x3, lsl 2]
	fadd	s0, s0, s1
	cmp	x2, x4
	bne	.L790
	sub	x2, x1, x0
	fsub	s0, s8, s0
	cmp	x24, x2, asr 3
	bhi	.L895
.L791:
	ldr	s1, [x0]
	fcmpe	s1, s0
	bgt	.L858
.L794:
	add	x22, x22, 1
	cmp	x6, x22
	bls	.L784
.L897:
	ldr	x4, [x23, 8]
	ldr	x5, [x27]
	mul	x2, x22, x4
	ldp	x0, x1, [sp, 176]
	cbnz	x4, .L896
.L841:
	sub	x2, x1, x0
	fmov	s0, 1.0e+0
	cmp	x24, x2, asr 3
	bls	.L791
.L895:
	ldr	x2, [sp, 192]
	str	s0, [sp, 144]
	str	w22, [sp, 148]
	cmp	x2, x1
	beq	.L792
	ldr	x2, [sp, 144]
	str	x2, [x1], 8
	str	x1, [sp, 184]
.L793:
	ldr	x3, [x1, -8]
	sub	x2, x1, x0
	add	x22, x22, 1
	asr	x1, x2, 3
	mov	x2, 0
	sub	x1, x1, #1
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldr	x6, [x23]
	cmp	x6, x22
	bhi	.L897
.L784:
	bl	_ZNSt6chrono3_V212system_clock3nowEv
	mov	x22, x0
	bl	_ZNSt6chrono3_V212system_clock3nowEv
	mov	x24, x0
	ldp	x0, x1, [sp, 176]
	stp	xzr, xzr, [x21]
	str	xzr, [x21, 16]
	cmp	x0, x1
	beq	.L806
	fmov	s8, 1.0e+0
.L805:
	sub	x2, x1, x0
	ldr	w11, [x0, 4]
	cmp	x2, 8
	bgt	.L898
.L807:
	ldr	x2, [x23, 8]
	uxtw	x5, w11
	ldr	x0, [sp, 184]
	mul	x5, x5, x2
	sub	x0, x0, #8
	str	x0, [sp, 184]
	add	x5, x25, x5, lsl 2
	cmp	x2, 3
	bls	.L850
	movi	v0.4s, 0
	mov	x4, x5
	mov	x3, x19
	mov	x0, 4
	b	.L815
	.p2align 2,,3
.L851:
	mov	x0, x1
.L815:
	ldr	q2, [x4], 16
	add	x1, x0, 4
	ldr	q1, [x3], 16
	fmla	v0.4s, v2.4s, v1.4s
	cmp	x2, x1
	bcs	.L851
.L814:
	faddp	v0.4s, v0.4s, v0.4s
	faddp	v0.4s, v0.4s, v0.4s
	cmp	x2, x0
	bls	.L816
	.p2align 3,,7
.L817:
	ldr	s2, [x5, x0, lsl 2]
	ldr	s1, [x19, x0, lsl 2]
	add	x0, x0, 1
	fmadd	s0, s2, s1, s0
	cmp	x2, x0
	bne	.L817
.L816:
	ldp	x0, x1, [x21]
	fsub	s0, s8, s0
	sub	x2, x1, x0
	cmp	x26, x2, asr 3
	bhi	.L899
	ldr	s1, [x0]
	fcmpe	s0, s1
	bmi	.L861
.L821:
	ldp	x0, x1, [sp, 176]
	cmp	x0, x1
	bne	.L805
.L806:
	bl	_ZNSt6chrono3_V212system_clock3nowEv
	ldr	x5, [sp, 136]
	cbz	x5, .L832
	mov	x1, 63439
	movk	x1, 0xe353, lsl 16
	ldr	x6, [sp, 128]
	movk	x1, 0x9ba5, lsl 32
	movk	x1, 0x20c4, lsl 48
	smulh	x4, x22, x1
	smulh	x3, x0, x1
	smulh	x2, x6, x1
	smulh	x1, x24, x1
	asr	x4, x4, 7
	asr	x3, x3, 7
	sub	x22, x4, x22, asr 63
	asr	x2, x2, 7
	sub	x0, x3, x0, asr 63
	asr	x1, x1, 7
	sub	x2, x2, x6, asr 63
	sub	x24, x1, x24, asr 63
	sub	x1, x22, x2
	sub	x0, x0, x24
	stp	x1, x0, [x5]
.L832:
	ldr	x0, [sp, 176]
	cbz	x0, .L833
	bl	_ZdlPv
.L833:
	cbz	x20, .L779
	mov	x0, x20
	bl	_ZdlPv
.L779:
	mov	x0, x21
	ldr	d8, [sp, 96]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 208
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_restore 72
	.cfi_def_cfa_offset 0
	ret
.L858:
	.cfi_restore_state
	ldr	x2, [sp, 192]
	str	s0, [sp, 152]
	str	w22, [sp, 156]
	cmp	x2, x1
	beq	.L796
	ldr	x2, [sp, 152]
	str	x2, [x1], 8
	str	x1, [sp, 184]
.L797:
	ldr	x3, [x1, -8]
	sub	x2, x1, x0
	asr	x1, x2, 3
	mov	x2, 0
	sub	x1, x1, #1
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldp	x0, x1, [sp, 176]
	sub	x2, x1, x0
	cmp	x2, 8
	bgt	.L900
.L798:
	sub	x1, x1, #8
	str	x1, [sp, 184]
	ldr	x6, [x23]
	b	.L794
.L899:
	ldr	x2, [x21, 16]
	str	s0, [sp, 160]
	str	w11, [sp, 164]
	cmp	x1, x2
	beq	.L819
	ldr	x2, [sp, 160]
	str	x2, [x1], 8
	str	x1, [x21, 8]
.L820:
	ldr	x3, [x1, -8]
	sub	x2, x1, x0
	asr	x1, x2, 3
	mov	x2, 0
	sub	x1, x1, #1
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	b	.L821
.L898:
	sub	x3, x1, #8
	ldr	w4, [x1, -8]
	sub	x3, x3, x0
	ldr	s0, [x0]
	ldr	w5, [x1, -4]
	asr	x8, x3, 3
	bfi	x28, x4, 0, 32
	sub	x2, x8, #1
	str	s0, [x1, -8]
	str	w11, [x1, -4]
	bfi	x28, x5, 32, 32
	add	x2, x2, x2, lsr 63
	asr	x6, x2, 1
	cmp	x3, 16
	ble	.L846
	mov	x3, 0
	b	.L812
.L848:
	mov	w4, w2
	.p2align 3,,7
.L811:
	lsl	x2, x3, 3
	add	x3, x0, x2
	str	s0, [x0, x2]
	str	w4, [x3, 4]
	cmp	x1, x6
	bge	.L808
.L849:
	mov	x3, x1
.L812:
	add	x2, x3, 1
	lsl	x5, x2, 1
	lsl	x2, x2, 4
	sub	x1, x5, #1
	add	x7, x0, x2
	lsl	x4, x1, 3
	ldr	s1, [x0, x2]
	add	x2, x0, x4
	ldr	s0, [x0, x4]
	fcmpe	s1, s0
	bmi	.L860
	ldr	w4, [x7, 4]
	bgt	.L847
	ldr	w2, [x2, 4]
	cmp	w2, w4
	bhi	.L848
.L847:
	fmov	s0, s1
	lsl	x2, x3, 3
	add	x3, x0, x2
	mov	x1, x5
	str	s0, [x0, x2]
	str	w4, [x3, 4]
	cmp	x1, x6
	blt	.L849
.L808:
	tbnz	x8, 0, .L813
	sub	x8, x8, #2
	add	x8, x8, x8, lsr 63
	cmp	x1, x8, asr 1
	bne	.L813
	lsl	x3, x1, 1
	lsl	x2, x1, 3
	add	x1, x3, 1
	add	x4, x0, x2
	lsl	x3, x1, 3
	add	x5, x0, x3
	ldr	s0, [x0, x3]
	ldr	w3, [x5, 4]
	str	s0, [x0, x2]
	str	w3, [x4, 4]
.L813:
	mov	x3, x28
	mov	x2, 0
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	b	.L807
	.p2align 2,,3
.L860:
	ldr	w4, [x2, 4]
	b	.L811
.L861:
	ldr	x2, [x21, 16]
	str	s0, [sp, 168]
	str	w11, [sp, 172]
	cmp	x1, x2
	beq	.L823
	ldr	x2, [sp, 168]
	str	x2, [x1], 8
	str	x1, [x21, 8]
.L824:
	ldr	x3, [x1, -8]
	sub	x2, x1, x0
	asr	x1, x2, 3
	mov	x2, 0
	sub	x1, x1, #1
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldp	x0, x1, [x21]
	sub	x2, x1, x0
	cmp	x2, 8
	bgt	.L901
.L825:
	sub	x1, x1, #8
	str	x1, [x21, 8]
	b	.L821
.L850:
	movi	v0.4s, 0
	mov	x0, 0
	b	.L814
.L901:
	sub	x3, x1, #8
	ldr	w4, [x1, -8]
	sub	x3, x3, x0
	ldr	w5, [x1, -4]
	ldr	x6, [sp, 120]
	asr	x7, x3, 3
	sub	x2, x7, #1
	ldr	s0, [x0]
	bfi	x6, x4, 0, 32
	add	x2, x2, x2, lsr 63
	ldr	w4, [x0, 4]
	bfi	x6, x5, 32, 32
	str	s0, [x1, -8]
	str	w4, [x1, -4]
	str	x6, [sp, 120]
	asr	x6, x2, 1
	cmp	x3, 16
	ble	.L852
	mov	x2, 0
	b	.L830
.L854:
	mov	w3, w4
.L829:
	lsl	x2, x2, 3
	add	x4, x0, x2
	str	s0, [x0, x2]
	str	w3, [x4, 4]
	cmp	x6, x1
	ble	.L826
.L855:
	mov	x2, x1
.L830:
	add	x3, x2, 1
	lsl	x5, x3, 1
	lsl	x3, x3, 4
	sub	x1, x5, #1
	add	x9, x0, x3
	lsl	x4, x1, 3
	ldr	s1, [x0, x3]
	add	x8, x0, x4
	ldr	s0, [x0, x4]
	fcmpe	s1, s0
	bmi	.L862
	ldr	w3, [x9, 4]
	bgt	.L853
	ldr	w4, [x8, 4]
	cmp	w4, w3
	bhi	.L854
.L853:
	fmov	s0, s1
	lsl	x2, x2, 3
	add	x4, x0, x2
	mov	x1, x5
	str	s0, [x0, x2]
	str	w3, [x4, 4]
	cmp	x6, x1
	bgt	.L855
.L826:
	tbnz	x7, 0, .L831
.L904:
	sub	x7, x7, #2
	add	x7, x7, x7, lsr 63
	cmp	x1, x7, asr 1
	beq	.L902
.L831:
	ldr	x3, [sp, 120]
	mov	x2, 0
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldr	x1, [x21, 8]
	b	.L825
.L862:
	ldr	w3, [x8, 4]
	b	.L829
.L900:
	sub	x3, x1, #8
	ldr	w4, [x1, -8]
	sub	x3, x3, x0
	ldr	w5, [x1, -4]
	ldr	x6, [sp, 112]
	asr	x7, x3, 3
	sub	x2, x7, #1
	ldr	s0, [x0]
	bfi	x6, x4, 0, 32
	add	x2, x2, x2, lsr 63
	ldr	w4, [x0, 4]
	bfi	x6, x5, 32, 32
	str	s0, [x1, -8]
	str	w4, [x1, -4]
	str	x6, [sp, 112]
	asr	x6, x2, 1
	cmp	x3, 16
	ble	.L842
	mov	x2, 0
	b	.L803
.L844:
	mov	w3, w4
.L802:
	lsl	x2, x2, 3
	add	x4, x0, x2
	str	s0, [x0, x2]
	str	w3, [x4, 4]
	cmp	x1, x6
	bge	.L799
.L845:
	mov	x2, x1
.L803:
	add	x3, x2, 1
	lsl	x5, x3, 1
	lsl	x3, x3, 4
	sub	x1, x5, #1
	add	x9, x0, x3
	lsl	x4, x1, 3
	ldr	s1, [x0, x3]
	add	x8, x0, x4
	ldr	s0, [x0, x4]
	fcmpe	s1, s0
	bmi	.L859
	ldr	w3, [x9, 4]
	bgt	.L843
	ldr	w4, [x8, 4]
	cmp	w4, w3
	bhi	.L844
.L843:
	fmov	s0, s1
	lsl	x2, x2, 3
	add	x4, x0, x2
	mov	x1, x5
	str	s0, [x0, x2]
	str	w3, [x4, 4]
	cmp	x1, x6
	blt	.L845
.L799:
	tbnz	x7, 0, .L804
.L905:
	sub	x7, x7, #2
	add	x7, x7, x7, lsr 63
	cmp	x1, x7, asr 1
	beq	.L903
.L804:
	ldr	x3, [sp, 112]
	mov	x2, 0
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldr	x1, [sp, 184]
	b	.L798
.L859:
	ldr	w3, [x8, 4]
	b	.L802
.L819:
	add	x2, sp, 160
	mov	x0, x21
.LEHB54:
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE54:
	ldp	x0, x1, [x21]
	b	.L820
.L792:
	add	x2, sp, 144
	add	x0, sp, 176
.LEHB55:
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	ldp	x0, x1, [sp, 176]
	b	.L793
.L796:
	add	x2, sp, 152
	add	x0, sp, 176
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE55:
	ldp	x0, x1, [sp, 176]
	b	.L797
.L823:
	add	x2, sp, 168
	mov	x0, x21
.LEHB56:
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE56:
	ldp	x0, x1, [x21]
	b	.L824
.L846:
	mov	x1, 0
	b	.L808
.L902:
	lsl	x3, x1, 1
	lsl	x2, x1, 3
	add	x1, x3, 1
	add	x4, x0, x2
	lsl	x3, x1, 3
	add	x5, x0, x3
	ldr	s0, [x0, x3]
	ldr	w3, [x5, 4]
	str	s0, [x0, x2]
	mov	x2, 0
	str	w3, [x4, 4]
	ldr	x3, [sp, 120]
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldr	x1, [x21, 8]
	b	.L825
.L903:
	lsl	x3, x1, 1
	lsl	x2, x1, 3
	add	x1, x3, 1
	add	x4, x0, x2
	lsl	x3, x1, 3
	add	x5, x0, x3
	ldr	s0, [x0, x3]
	ldr	w3, [x5, 4]
	str	s0, [x0, x2]
	mov	x2, 0
	str	w3, [x4, 4]
	ldr	x3, [sp, 112]
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldr	x1, [sp, 184]
	b	.L798
.L852:
	mov	x1, 0
	tbnz	x7, 0, .L831
	b	.L904
.L842:
	mov	x1, 0
	tbnz	x7, 0, .L804
	b	.L905
.L894:
	adrp	x0, .LC37
	add	x0, x0, :lo12:.LC37
.LEHB57:
	bl	_ZSt20__throw_length_errorPKc
.L857:
	ldr	x1, [x21]
	mov	x19, x0
	cbz	x1, .L837
	mov	x0, x1
	bl	_ZdlPv
.L837:
	ldr	x0, [sp, 176]
	cbz	x0, .L838
	bl	_ZdlPv
.L838:
	cbz	x20, .L839
	mov	x0, x20
	bl	_ZdlPv
.L839:
	mov	x0, x19
	bl	_Unwind_Resume
.LEHE57:
.L856:
	mov	x19, x0
	b	.L837
	.cfi_endproc
.LFE10423:
	.section	.gcc_except_table
.LLSDA10423:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE10423-.LLSDACSB10423
.LLSDACSB10423:
	.uleb128 .LEHB53-.LFB10423
	.uleb128 .LEHE53-.LEHB53
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB54-.LFB10423
	.uleb128 .LEHE54-.LEHB54
	.uleb128 .L857-.LFB10423
	.uleb128 0
	.uleb128 .LEHB55-.LFB10423
	.uleb128 .LEHE55-.LEHB55
	.uleb128 .L856-.LFB10423
	.uleb128 0
	.uleb128 .LEHB56-.LFB10423
	.uleb128 .LEHE56-.LEHB56
	.uleb128 .L857-.LFB10423
	.uleb128 0
	.uleb128 .LEHB57-.LFB10423
	.uleb128 .LEHE57-.LEHB57
	.uleb128 0
	.uleb128 0
.LLSDACSE10423:
	.section	.text._ZN3ann23sq8_search_rerank_timedERKNS_8SQ8IndexEPKfS4_mmPNS_11QuantTimingE,"axG",@progbits,_ZN3ann23sq8_search_rerank_timedERKNS_8SQ8IndexEPKfS4_mmPNS_11QuantTimingE,comdat
	.size	_ZN3ann23sq8_search_rerank_timedERKNS_8SQ8IndexEPKfS4_mmPNS_11QuantTimingE, .-_ZN3ann23sq8_search_rerank_timedERKNS_8SQ8IndexEPKfS4_mmPNS_11QuantTimingE
	.text
	.align	2
	.p2align 4,,11
	.global	_Z14run_sq8_methodRKN3ann8SQ8IndexEPfS3_Pimmmm
	.type	_Z14run_sq8_methodRKN3ann8SQ8IndexEPfS3_Pimmmm, %function
_Z14run_sq8_methodRKN3ann8SQ8IndexEPfS3_Pimmmm:
.LFB10466:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA10466
	stp	x29, x30, [sp, -240]!
	.cfi_def_cfa_offset 240
	.cfi_offset 29, -240
	.cfi_offset 30, -232
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x5, x1, [sp, 120]
	stp	x2, x3, [sp, 136]
	str	x8, [sp, 152]
	str	d8, [sp, 96]
	.cfi_offset 21, -208
	.cfi_offset 22, -200
	.cfi_offset 23, -192
	.cfi_offset 24, -184
	.cfi_offset 72, -144
	cbz	x5, .L919
	movi	v8.2s, #0
	mov	x24, x0
	stp	x25, x26, [sp, 64]
	.cfi_offset 26, -168
	.cfi_offset 25, -176
	mov	x26, 16960
	mov	x25, x7
	stp	x27, x28, [sp, 80]
	.cfi_offset 28, -152
	.cfi_offset 27, -160
	mov	x27, x4
	mov	x28, x6
	mov	x21, 0
	mov	x22, 0
	mov	x23, 0
	movk	x26, 0xf, lsl 16
	stp	x19, x20, [sp, 16]
	.cfi_offset 20, -216
	.cfi_offset 19, -224
	mov	x20, 0
	.p2align 3,,7
.L914:
	mov	x1, 0
	add	x0, sp, 208
	stp	xzr, xzr, [sp, 160]
	bl	gettimeofday
	ldr	x2, [x24, 8]
	mov	x3, x28
	ldp	x1, x0, [sp, 128]
	add	x8, sp, 176
	ldp	x19, x6, [sp, 208]
	mul	x2, x20, x2
	add	x5, sp, 160
	mov	x4, x25
	add	x2, x0, x2, lsl 2
	mov	x0, x24
	madd	x19, x19, x26, x6
.LEHB58:
	bl	_ZN3ann23sq8_search_rerank_timedERKNS_8SQ8IndexEPKfS4_mmPNS_11QuantTimingE
.LEHE58:
	mov	x1, 0
	add	x0, sp, 208
	bl	gettimeofday
	str	xzr, [sp, 224]
	ldp	x0, x1, [sp, 208]
	stp	xzr, xzr, [sp, 208]
	ldr	x2, [sp, 160]
	ldr	x3, [sp, 176]
	madd	x0, x0, x26, x1
	ldr	x1, [sp, 168]
	sub	x0, x0, x19
	add	x23, x23, x0
	add	x22, x22, x2
	ldr	x0, [sp, 184]
	add	x21, x21, x1
	subs	x19, x0, x3
	beq	.L920
	mov	x0, 9223372036854775800
	cmp	x19, x0
	bhi	.L939
	mov	x0, x19
.LEHB59:
	bl	_Znwm
.LEHE59:
	mov	x5, x0
	ldp	x3, x0, [sp, 176]
.L908:
	add	x19, x5, x19
	stp	x5, x5, [sp, 208]
	str	x19, [sp, 224]
	cmp	x0, x3
	beq	.L910
	sub	x0, x0, x3
	mov	x1, 0
	.p2align 3,,7
.L911:
	ldr	x2, [x3, x1]
	str	x2, [x5, x1]
	add	x1, x1, 8
	cmp	x1, x0
	bne	.L911
	add	x5, x5, x1
.L910:
	ldr	x1, [sp, 144]
	mov	x4, x25
	mov	x3, x20
	mov	x2, x27
	add	x0, sp, 208
	str	x5, [sp, 216]
.LEHB60:
	bl	_Z11calc_recallSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EESt4lessIS1_EEPimmm
.LEHE60:
	ldr	x0, [sp, 208]
	fadd	s8, s8, s0
	cbz	x0, .L912
	bl	_ZdlPv
.L912:
	ldr	x0, [sp, 176]
	cbz	x0, .L913
	bl	_ZdlPv
.L913:
	ldr	x0, [sp, 120]
	add	x20, x20, 1
	cmp	x0, x20
	bne	.L914
	ldp	x19, x20, [sp, 16]
	.cfi_restore 20
	.cfi_restore 19
	ldp	x25, x26, [sp, 64]
	.cfi_restore 26
	.cfi_restore 25
	ldp	x27, x28, [sp, 80]
	.cfi_restore 28
	.cfi_restore 27
	sdiv	x23, x23, x0
	sdiv	x22, x22, x0
	sdiv	x21, x21, x0
.L907:
	ldr	x0, [sp, 120]
	ucvtf	s0, x0
	ldr	x0, [sp, 152]
	fdiv	s8, s8, s0
	stp	x23, x22, [x0, 8]
	str	x21, [x0, 24]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	str	s8, [x0]
	ldr	d8, [sp, 96]
	ldp	x29, x30, [sp], 240
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 72
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L920:
	.cfi_def_cfa_offset 240
	.cfi_offset 19, -224
	.cfi_offset 20, -216
	.cfi_offset 21, -208
	.cfi_offset 22, -200
	.cfi_offset 23, -192
	.cfi_offset 24, -184
	.cfi_offset 25, -176
	.cfi_offset 26, -168
	.cfi_offset 27, -160
	.cfi_offset 28, -152
	.cfi_offset 29, -240
	.cfi_offset 30, -232
	.cfi_offset 72, -144
	mov	x19, 0
	mov	x5, 0
	b	.L908
.L919:
	.cfi_restore 19
	.cfi_restore 20
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 27
	.cfi_restore 28
	movi	v8.2s, #0
	mov	x21, 0
	mov	x22, 0
	mov	x23, 0
	b	.L907
.L939:
	.cfi_offset 19, -224
	.cfi_offset 20, -216
	.cfi_offset 25, -176
	.cfi_offset 26, -168
	.cfi_offset 27, -160
	.cfi_offset 28, -152
.LEHB61:
	bl	_ZSt17__throw_bad_allocv
.LEHE61:
.L922:
	ldr	x1, [sp, 208]
	mov	x19, x0
	cbz	x1, .L917
	mov	x0, x1
	bl	_ZdlPv
.L917:
	ldr	x0, [sp, 176]
	cbz	x0, .L918
	bl	_ZdlPv
.L918:
	mov	x0, x19
.LEHB62:
	bl	_Unwind_Resume
.LEHE62:
.L921:
	mov	x19, x0
	b	.L917
	.cfi_endproc
.LFE10466:
	.section	.gcc_except_table
.LLSDA10466:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE10466-.LLSDACSB10466
.LLSDACSB10466:
	.uleb128 .LEHB58-.LFB10466
	.uleb128 .LEHE58-.LEHB58
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB59-.LFB10466
	.uleb128 .LEHE59-.LEHB59
	.uleb128 .L921-.LFB10466
	.uleb128 0
	.uleb128 .LEHB60-.LFB10466
	.uleb128 .LEHE60-.LEHB60
	.uleb128 .L922-.LFB10466
	.uleb128 0
	.uleb128 .LEHB61-.LFB10466
	.uleb128 .LEHE61-.LEHB61
	.uleb128 .L921-.LFB10466
	.uleb128 0
	.uleb128 .LEHB62-.LFB10466
	.uleb128 .LEHE62-.LEHB62
	.uleb128 0
	.uleb128 0
.LLSDACSE10466:
	.text
	.size	_Z14run_sq8_methodRKN3ann8SQ8IndexEPfS3_Pimmmm, .-_Z14run_sq8_methodRKN3ann8SQ8IndexEPfS3_Pimmmm
	.section	.text._ZN3ann26pq_adc_search_rerank_timedERKNS_7PQIndexEPKfS4_mmPNS_11QuantTimingE,"axG",@progbits,_ZN3ann26pq_adc_search_rerank_timedERKNS_7PQIndexEPKfS4_mmPNS_11QuantTimingE,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN3ann26pq_adc_search_rerank_timedERKNS_7PQIndexEPKfS4_mmPNS_11QuantTimingE
	.type	_ZN3ann26pq_adc_search_rerank_timedERKNS_7PQIndexEPKfS4_mmPNS_11QuantTimingE, %function
_ZN3ann26pq_adc_search_rerank_timedERKNS_7PQIndexEPKfS4_mmPNS_11QuantTimingE:
.LFB10432:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA10432
	stp	x29, x30, [sp, -208]!
	.cfi_def_cfa_offset 208
	.cfi_offset 29, -208
	.cfi_offset 30, -200
	mov	x29, sp
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -160
	.cfi_offset 24, -152
	mov	x23, x0
	ldr	x24, [x0]
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -192
	.cfi_offset 20, -184
	mov	x19, x2
	cmp	x24, x3
	stp	x21, x22, [sp, 32]
	csel	x24, x24, x3, ls
	.cfi_offset 21, -176
	.cfi_offset 22, -168
	mov	x21, x8
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -144
	.cfi_offset 26, -136
	mov	x25, x1
	mov	x26, x4
	stp	x27, x28, [sp, 80]
	str	d8, [sp, 96]
	.cfi_offset 27, -128
	.cfi_offset 28, -120
	.cfi_offset 72, -112
	str	x5, [sp, 136]
	bl	_ZNSt6chrono3_V212system_clock3nowEv
	ldr	w5, [x23, 16]
	mov	x1, 2305843009213693951
	str	x0, [sp, 128]
	ldr	w0, [x23, 20]
	smull	x0, w5, w0
	cmp	x0, x1
	bhi	.L1059
	mov	x20, 0
	cbz	x0, .L942
	lsl	x22, x0, 2
	mov	x0, x22
.LEHB63:
	bl	_Znwm
.LEHE63:
	mov	x2, x22
	mov	x20, x0
	mov	w1, 0
	bl	memset
	ldr	w5, [x23, 16]
.L942:
	cmp	w5, 0
	ble	.L947
	ldp	w12, w2, [x23, 20]
	mov	x10, x20
	ldr	x14, [x23, 40]
	sub	w6, w12, #1
	add	x6, x6, 1
	smull	x13, w2, w12
	mov	x3, x19
	sbfiz	x11, x12, 2, 32
	add	x6, x20, x6, lsl 2
	sbfiz	x7, x2, 2, 32
	mov	x9, 0
	mov	w8, 0
	.p2align 3,,7
.L948:
	add	x1, x14, x9, lsl 2
	mov	x4, x10
	cmp	w12, 0
	ble	.L951
	.p2align 3,,7
.L952:
	movi	v0.2s, #0
	cmp	w2, 0
	ble	.L949
	mov	x0, 0
	.p2align 3,,7
.L950:
	ldr	s2, [x1, x0, lsl 2]
	ldr	s1, [x3, x0, lsl 2]
	add	x0, x0, 1
	fmadd	s0, s2, s1, s0
	cmp	w2, w0
	bgt	.L950
.L949:
	add	x1, x1, x7
	str	s0, [x4], 4
	cmp	x6, x4
	bne	.L952
.L951:
	add	w8, w8, 1
	add	x6, x6, x11
	add	x10, x10, x11
	add	x9, x9, x13
	add	x3, x3, x7
	cmp	w8, w5
	bne	.L948
.L947:
	ldr	x7, [x23]
	stp	xzr, xzr, [sp, 176]
	str	xzr, [sp, 192]
	cbz	x7, .L944
	sxtw	x2, w5
	mov	x22, 0
	add	x27, x23, 64
	mov	x0, 0
	mov	x1, 0
	fmov	s8, 1.0e+0
	mul	x2, x2, x22
	ldr	x3, [x27]
	cmp	w5, 0
	ble	.L1006
	.p2align 3,,7
.L1061:
	sub	w5, w5, #1
	movi	v0.2s, #0
	ldrsw	x6, [x23, 20]
	add	x4, x3, 1
	add	x5, x5, x2
	add	x3, x3, x2
	add	x5, x5, x4
	mov	x4, 0
	.p2align 3,,7
.L954:
	ldrb	w2, [x3], 1
	add	x2, x2, x4
	add	x4, x4, x6
	ldr	s1, [x20, x2, lsl 2]
	fadd	s0, s0, s1
	cmp	x5, x3
	bne	.L954
	sub	x2, x1, x0
	fsub	s0, s8, s0
	cmp	x24, x2, asr 3
	bhi	.L1060
.L955:
	ldr	s1, [x0]
	fcmpe	s1, s0
	bgt	.L1023
.L958:
	add	x22, x22, 1
	cmp	x7, x22
	bls	.L944
.L1062:
	ldr	w5, [x23, 16]
	ldr	x3, [x27]
	sxtw	x2, w5
	ldp	x0, x1, [sp, 176]
	mul	x2, x2, x22
	cmp	w5, 0
	bgt	.L1061
.L1006:
	sub	x2, x1, x0
	fmov	s0, 1.0e+0
	cmp	x24, x2, asr 3
	bls	.L955
.L1060:
	ldr	x2, [sp, 192]
	str	s0, [sp, 144]
	str	w22, [sp, 148]
	cmp	x2, x1
	beq	.L956
	ldr	x2, [sp, 144]
	str	x2, [x1], 8
	str	x1, [sp, 184]
.L957:
	ldr	x3, [x1, -8]
	sub	x2, x1, x0
	add	x22, x22, 1
	asr	x1, x2, 3
	mov	x2, 0
	sub	x1, x1, #1
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldr	x7, [x23]
	cmp	x7, x22
	bhi	.L1062
.L944:
	bl	_ZNSt6chrono3_V212system_clock3nowEv
	mov	x22, x0
	bl	_ZNSt6chrono3_V212system_clock3nowEv
	mov	x24, x0
	ldp	x0, x1, [sp, 176]
	stp	xzr, xzr, [x21]
	str	xzr, [x21, 16]
	cmp	x1, x0
	beq	.L970
	fmov	s8, 1.0e+0
	.p2align 3,,7
.L969:
	sub	x2, x1, x0
	ldr	w11, [x0, 4]
	cmp	x2, 8
	bgt	.L1063
.L971:
	ldr	x2, [x23, 8]
	uxtw	x5, w11
	ldr	x0, [sp, 184]
	mul	x5, x5, x2
	sub	x0, x0, #8
	str	x0, [sp, 184]
	add	x5, x25, x5, lsl 2
	cmp	x2, 3
	bls	.L1015
	movi	v0.4s, 0
	mov	x4, x5
	mov	x3, x19
	mov	x0, 4
	b	.L979
	.p2align 2,,3
.L1016:
	mov	x0, x1
.L979:
	ldr	q2, [x4], 16
	add	x1, x0, 4
	ldr	q1, [x3], 16
	fmla	v0.4s, v2.4s, v1.4s
	cmp	x2, x1
	bcs	.L1016
.L978:
	faddp	v0.4s, v0.4s, v0.4s
	faddp	v0.4s, v0.4s, v0.4s
	cmp	x2, x0
	bls	.L980
	.p2align 3,,7
.L981:
	ldr	s2, [x5, x0, lsl 2]
	ldr	s1, [x19, x0, lsl 2]
	add	x0, x0, 1
	fmadd	s0, s2, s1, s0
	cmp	x2, x0
	bne	.L981
.L980:
	ldp	x0, x1, [x21]
	fsub	s0, s8, s0
	sub	x2, x1, x0
	cmp	x26, x2, asr 3
	bhi	.L1064
	ldr	s1, [x0]
	fcmpe	s0, s1
	bmi	.L1026
.L985:
	ldp	x0, x1, [sp, 176]
	cmp	x0, x1
	bne	.L969
.L970:
	bl	_ZNSt6chrono3_V212system_clock3nowEv
	ldr	x5, [sp, 136]
	cbz	x5, .L996
	mov	x1, 63439
	movk	x1, 0xe353, lsl 16
	ldr	x6, [sp, 128]
	movk	x1, 0x9ba5, lsl 32
	movk	x1, 0x20c4, lsl 48
	smulh	x4, x22, x1
	smulh	x3, x0, x1
	smulh	x2, x6, x1
	smulh	x1, x24, x1
	asr	x4, x4, 7
	asr	x3, x3, 7
	sub	x22, x4, x22, asr 63
	asr	x2, x2, 7
	sub	x0, x3, x0, asr 63
	asr	x1, x1, 7
	sub	x2, x2, x6, asr 63
	sub	x24, x1, x24, asr 63
	sub	x1, x22, x2
	sub	x0, x0, x24
	stp	x1, x0, [x5]
.L996:
	ldr	x0, [sp, 176]
	cbz	x0, .L997
	bl	_ZdlPv
.L997:
	cbz	x20, .L940
	mov	x0, x20
	bl	_ZdlPv
.L940:
	mov	x0, x21
	ldr	d8, [sp, 96]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 208
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_restore 72
	.cfi_def_cfa_offset 0
	ret
.L1023:
	.cfi_restore_state
	ldr	x2, [sp, 192]
	str	s0, [sp, 152]
	str	w22, [sp, 156]
	cmp	x2, x1
	beq	.L960
	ldr	x2, [sp, 152]
	str	x2, [x1], 8
	str	x1, [sp, 184]
.L961:
	ldr	x3, [x1, -8]
	sub	x2, x1, x0
	asr	x1, x2, 3
	mov	x2, 0
	sub	x1, x1, #1
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldp	x0, x1, [sp, 176]
	sub	x2, x1, x0
	cmp	x2, 8
	bgt	.L1065
.L962:
	sub	x1, x1, #8
	str	x1, [sp, 184]
	ldr	x7, [x23]
	b	.L958
.L1064:
	ldr	x2, [x21, 16]
	str	s0, [sp, 160]
	str	w11, [sp, 164]
	cmp	x1, x2
	beq	.L983
	ldr	x2, [sp, 160]
	str	x2, [x1], 8
	str	x1, [x21, 8]
.L984:
	ldr	x3, [x1, -8]
	sub	x2, x1, x0
	asr	x1, x2, 3
	mov	x2, 0
	sub	x1, x1, #1
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	b	.L985
.L1063:
	sub	x3, x1, #8
	ldr	w4, [x1, -8]
	sub	x3, x3, x0
	ldr	s0, [x0]
	ldr	w5, [x1, -4]
	asr	x9, x3, 3
	bfi	x28, x4, 0, 32
	sub	x2, x9, #1
	str	s0, [x1, -8]
	str	w11, [x1, -4]
	bfi	x28, x5, 32, 32
	add	x2, x2, x2, lsr 63
	asr	x7, x2, 1
	cmp	x3, 16
	ble	.L1011
	mov	x2, 0
	b	.L976
.L1013:
	mov	w3, w4
	.p2align 3,,7
.L975:
	lsl	x2, x2, 3
	add	x4, x0, x2
	str	s0, [x0, x2]
	str	w3, [x4, 4]
	cmp	x1, x7
	bge	.L972
.L1014:
	mov	x2, x1
.L976:
	add	x3, x2, 1
	lsl	x5, x3, 1
	lsl	x3, x3, 4
	sub	x1, x5, #1
	add	x8, x0, x3
	lsl	x4, x1, 3
	ldr	s1, [x0, x3]
	add	x6, x0, x4
	ldr	s0, [x0, x4]
	fcmpe	s1, s0
	bmi	.L1025
	ldr	w3, [x8, 4]
	bgt	.L1012
	ldr	w4, [x6, 4]
	cmp	w4, w3
	bhi	.L1013
.L1012:
	fmov	s0, s1
	lsl	x2, x2, 3
	add	x4, x0, x2
	mov	x1, x5
	str	s0, [x0, x2]
	str	w3, [x4, 4]
	cmp	x1, x7
	blt	.L1014
.L972:
	tbnz	x9, 0, .L977
	sub	x9, x9, #2
	add	x9, x9, x9, lsr 63
	cmp	x1, x9, asr 1
	bne	.L977
	lsl	x3, x1, 1
	lsl	x2, x1, 3
	add	x1, x3, 1
	add	x4, x0, x2
	lsl	x3, x1, 3
	add	x5, x0, x3
	ldr	s0, [x0, x3]
	ldr	w3, [x5, 4]
	str	s0, [x0, x2]
	str	w3, [x4, 4]
.L977:
	mov	x3, x28
	mov	x2, 0
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	b	.L971
	.p2align 2,,3
.L1025:
	ldr	w3, [x6, 4]
	b	.L975
.L1026:
	ldr	x2, [x21, 16]
	str	s0, [sp, 168]
	str	w11, [sp, 172]
	cmp	x1, x2
	beq	.L987
	ldr	x2, [sp, 168]
	str	x2, [x1], 8
	str	x1, [x21, 8]
.L988:
	ldr	x3, [x1, -8]
	sub	x2, x1, x0
	asr	x1, x2, 3
	mov	x2, 0
	sub	x1, x1, #1
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldp	x0, x1, [x21]
	sub	x2, x1, x0
	cmp	x2, 8
	bgt	.L1066
.L989:
	sub	x1, x1, #8
	str	x1, [x21, 8]
	b	.L985
.L1015:
	movi	v0.4s, 0
	mov	x0, 0
	b	.L978
.L1066:
	sub	x3, x1, #8
	ldr	w4, [x1, -8]
	sub	x3, x3, x0
	ldr	w5, [x1, -4]
	ldr	x6, [sp, 120]
	asr	x9, x3, 3
	sub	x2, x9, #1
	ldr	s0, [x0]
	bfi	x6, x4, 0, 32
	add	x2, x2, x2, lsr 63
	ldr	w4, [x0, 4]
	bfi	x6, x5, 32, 32
	str	s0, [x1, -8]
	str	w4, [x1, -4]
	str	x6, [sp, 120]
	asr	x6, x2, 1
	cmp	x3, 16
	ble	.L1017
	mov	x2, 0
	b	.L994
.L1019:
	mov	w3, w4
.L993:
	lsl	x2, x2, 3
	add	x4, x0, x2
	str	s0, [x0, x2]
	str	w3, [x4, 4]
	cmp	x6, x1
	ble	.L990
.L1020:
	mov	x2, x1
.L994:
	add	x3, x2, 1
	lsl	x5, x3, 1
	lsl	x3, x3, 4
	sub	x1, x5, #1
	add	x8, x0, x3
	lsl	x4, x1, 3
	ldr	s1, [x0, x3]
	add	x7, x0, x4
	ldr	s0, [x0, x4]
	fcmpe	s1, s0
	bmi	.L1027
	ldr	w3, [x8, 4]
	bgt	.L1018
	ldr	w4, [x7, 4]
	cmp	w4, w3
	bhi	.L1019
.L1018:
	fmov	s0, s1
	lsl	x2, x2, 3
	add	x4, x0, x2
	mov	x1, x5
	str	s0, [x0, x2]
	str	w3, [x4, 4]
	cmp	x6, x1
	bgt	.L1020
.L990:
	tbnz	x9, 0, .L995
.L1069:
	sub	x9, x9, #2
	add	x9, x9, x9, lsr 63
	cmp	x1, x9, asr 1
	beq	.L1067
.L995:
	ldr	x3, [sp, 120]
	mov	x2, 0
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldr	x1, [x21, 8]
	b	.L989
.L1027:
	ldr	w3, [x7, 4]
	b	.L993
.L1065:
	sub	x3, x1, #8
	ldr	w4, [x1, -8]
	sub	x3, x3, x0
	ldr	w5, [x1, -4]
	ldr	x6, [sp, 112]
	asr	x9, x3, 3
	sub	x2, x9, #1
	ldr	s0, [x0]
	bfi	x6, x4, 0, 32
	add	x2, x2, x2, lsr 63
	ldr	w4, [x0, 4]
	bfi	x6, x5, 32, 32
	str	s0, [x1, -8]
	str	w4, [x1, -4]
	str	x6, [sp, 112]
	asr	x6, x2, 1
	cmp	x3, 16
	ble	.L1007
	mov	x2, 0
	b	.L967
.L1009:
	mov	w3, w4
.L966:
	lsl	x2, x2, 3
	add	x4, x0, x2
	str	s0, [x0, x2]
	str	w3, [x4, 4]
	cmp	x1, x6
	bge	.L963
.L1010:
	mov	x2, x1
.L967:
	add	x3, x2, 1
	lsl	x5, x3, 1
	lsl	x3, x3, 4
	sub	x1, x5, #1
	add	x8, x0, x3
	lsl	x4, x1, 3
	ldr	s1, [x0, x3]
	add	x7, x0, x4
	ldr	s0, [x0, x4]
	fcmpe	s1, s0
	bmi	.L1024
	ldr	w3, [x8, 4]
	bgt	.L1008
	ldr	w4, [x7, 4]
	cmp	w4, w3
	bhi	.L1009
.L1008:
	fmov	s0, s1
	lsl	x2, x2, 3
	add	x4, x0, x2
	mov	x1, x5
	str	s0, [x0, x2]
	str	w3, [x4, 4]
	cmp	x1, x6
	blt	.L1010
.L963:
	tbnz	x9, 0, .L968
.L1070:
	sub	x9, x9, #2
	add	x9, x9, x9, lsr 63
	cmp	x1, x9, asr 1
	beq	.L1068
.L968:
	ldr	x3, [sp, 112]
	mov	x2, 0
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldr	x1, [sp, 184]
	b	.L962
.L1024:
	ldr	w3, [x7, 4]
	b	.L966
.L983:
	add	x2, sp, 160
	mov	x0, x21
.LEHB64:
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE64:
	ldp	x0, x1, [x21]
	b	.L984
.L956:
	add	x2, sp, 144
	add	x0, sp, 176
.LEHB65:
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	ldp	x0, x1, [sp, 176]
	b	.L957
.L960:
	add	x2, sp, 152
	add	x0, sp, 176
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE65:
	ldp	x0, x1, [sp, 176]
	b	.L961
.L987:
	add	x2, sp, 168
	mov	x0, x21
.LEHB66:
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE66:
	ldp	x0, x1, [x21]
	b	.L988
.L1011:
	mov	x1, 0
	b	.L972
.L1067:
	lsl	x3, x1, 1
	lsl	x2, x1, 3
	add	x1, x3, 1
	add	x4, x0, x2
	lsl	x3, x1, 3
	add	x5, x0, x3
	ldr	s0, [x0, x3]
	ldr	w3, [x5, 4]
	str	s0, [x0, x2]
	mov	x2, 0
	str	w3, [x4, 4]
	ldr	x3, [sp, 120]
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldr	x1, [x21, 8]
	b	.L989
.L1068:
	lsl	x3, x1, 1
	lsl	x2, x1, 3
	add	x1, x3, 1
	add	x4, x0, x2
	lsl	x3, x1, 3
	add	x5, x0, x3
	ldr	s0, [x0, x3]
	ldr	w3, [x5, 4]
	str	s0, [x0, x2]
	mov	x2, 0
	str	w3, [x4, 4]
	ldr	x3, [sp, 112]
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldr	x1, [sp, 184]
	b	.L962
.L1017:
	mov	x1, 0
	tbnz	x9, 0, .L995
	b	.L1069
.L1007:
	mov	x1, 0
	tbnz	x9, 0, .L968
	b	.L1070
.L1059:
	adrp	x0, .LC37
	add	x0, x0, :lo12:.LC37
.LEHB67:
	bl	_ZSt20__throw_length_errorPKc
.L1022:
	ldr	x1, [x21]
	mov	x19, x0
	cbz	x1, .L1001
	mov	x0, x1
	bl	_ZdlPv
.L1001:
	ldr	x0, [sp, 176]
	cbz	x0, .L1002
	bl	_ZdlPv
.L1002:
	cbz	x20, .L1003
	mov	x0, x20
	bl	_ZdlPv
.L1003:
	mov	x0, x19
	bl	_Unwind_Resume
.LEHE67:
.L1021:
	mov	x19, x0
	b	.L1001
	.cfi_endproc
.LFE10432:
	.section	.gcc_except_table
.LLSDA10432:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE10432-.LLSDACSB10432
.LLSDACSB10432:
	.uleb128 .LEHB63-.LFB10432
	.uleb128 .LEHE63-.LEHB63
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB64-.LFB10432
	.uleb128 .LEHE64-.LEHB64
	.uleb128 .L1022-.LFB10432
	.uleb128 0
	.uleb128 .LEHB65-.LFB10432
	.uleb128 .LEHE65-.LEHB65
	.uleb128 .L1021-.LFB10432
	.uleb128 0
	.uleb128 .LEHB66-.LFB10432
	.uleb128 .LEHE66-.LEHB66
	.uleb128 .L1022-.LFB10432
	.uleb128 0
	.uleb128 .LEHB67-.LFB10432
	.uleb128 .LEHE67-.LEHB67
	.uleb128 0
	.uleb128 0
.LLSDACSE10432:
	.section	.text._ZN3ann26pq_adc_search_rerank_timedERKNS_7PQIndexEPKfS4_mmPNS_11QuantTimingE,"axG",@progbits,_ZN3ann26pq_adc_search_rerank_timedERKNS_7PQIndexEPKfS4_mmPNS_11QuantTimingE,comdat
	.size	_ZN3ann26pq_adc_search_rerank_timedERKNS_7PQIndexEPKfS4_mmPNS_11QuantTimingE, .-_ZN3ann26pq_adc_search_rerank_timedERKNS_7PQIndexEPKfS4_mmPNS_11QuantTimingE
	.text
	.align	2
	.p2align 4,,11
	.global	_Z13run_pq_methodRKN3ann7PQIndexEPfS3_Pimmmm
	.type	_Z13run_pq_methodRKN3ann7PQIndexEPfS3_Pimmmm, %function
_Z13run_pq_methodRKN3ann7PQIndexEPfS3_Pimmmm:
.LFB10468:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA10468
	stp	x29, x30, [sp, -240]!
	.cfi_def_cfa_offset 240
	.cfi_offset 29, -240
	.cfi_offset 30, -232
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x5, x1, [sp, 120]
	stp	x2, x3, [sp, 136]
	str	x8, [sp, 152]
	str	d8, [sp, 96]
	.cfi_offset 21, -208
	.cfi_offset 22, -200
	.cfi_offset 23, -192
	.cfi_offset 24, -184
	.cfi_offset 72, -144
	cbz	x5, .L1084
	movi	v8.2s, #0
	mov	x24, x0
	stp	x25, x26, [sp, 64]
	.cfi_offset 26, -168
	.cfi_offset 25, -176
	mov	x26, 16960
	mov	x25, x7
	stp	x27, x28, [sp, 80]
	.cfi_offset 28, -152
	.cfi_offset 27, -160
	mov	x27, x4
	mov	x28, x6
	mov	x21, 0
	mov	x22, 0
	mov	x23, 0
	movk	x26, 0xf, lsl 16
	stp	x19, x20, [sp, 16]
	.cfi_offset 20, -216
	.cfi_offset 19, -224
	mov	x20, 0
	.p2align 3,,7
.L1079:
	mov	x1, 0
	add	x0, sp, 208
	stp	xzr, xzr, [sp, 160]
	bl	gettimeofday
	ldr	x2, [x24, 8]
	mov	x3, x28
	ldp	x1, x0, [sp, 128]
	add	x8, sp, 176
	ldp	x19, x6, [sp, 208]
	mul	x2, x20, x2
	add	x5, sp, 160
	mov	x4, x25
	add	x2, x0, x2, lsl 2
	mov	x0, x24
	madd	x19, x19, x26, x6
.LEHB68:
	bl	_ZN3ann26pq_adc_search_rerank_timedERKNS_7PQIndexEPKfS4_mmPNS_11QuantTimingE
.LEHE68:
	mov	x1, 0
	add	x0, sp, 208
	bl	gettimeofday
	str	xzr, [sp, 224]
	ldp	x0, x1, [sp, 208]
	stp	xzr, xzr, [sp, 208]
	ldr	x2, [sp, 160]
	ldr	x3, [sp, 176]
	madd	x0, x0, x26, x1
	ldr	x1, [sp, 168]
	sub	x0, x0, x19
	add	x23, x23, x0
	add	x22, x22, x2
	ldr	x0, [sp, 184]
	add	x21, x21, x1
	subs	x19, x0, x3
	beq	.L1085
	mov	x0, 9223372036854775800
	cmp	x19, x0
	bhi	.L1104
	mov	x0, x19
.LEHB69:
	bl	_Znwm
.LEHE69:
	mov	x5, x0
	ldp	x3, x0, [sp, 176]
.L1073:
	add	x19, x5, x19
	stp	x5, x5, [sp, 208]
	str	x19, [sp, 224]
	cmp	x0, x3
	beq	.L1075
	sub	x0, x0, x3
	mov	x1, 0
	.p2align 3,,7
.L1076:
	ldr	x2, [x3, x1]
	str	x2, [x5, x1]
	add	x1, x1, 8
	cmp	x1, x0
	bne	.L1076
	add	x5, x5, x1
.L1075:
	ldr	x1, [sp, 144]
	mov	x4, x25
	mov	x3, x20
	mov	x2, x27
	add	x0, sp, 208
	str	x5, [sp, 216]
.LEHB70:
	bl	_Z11calc_recallSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EESt4lessIS1_EEPimmm
.LEHE70:
	ldr	x0, [sp, 208]
	fadd	s8, s8, s0
	cbz	x0, .L1077
	bl	_ZdlPv
.L1077:
	ldr	x0, [sp, 176]
	cbz	x0, .L1078
	bl	_ZdlPv
.L1078:
	ldr	x0, [sp, 120]
	add	x20, x20, 1
	cmp	x0, x20
	bne	.L1079
	ldp	x19, x20, [sp, 16]
	.cfi_restore 20
	.cfi_restore 19
	ldp	x25, x26, [sp, 64]
	.cfi_restore 26
	.cfi_restore 25
	ldp	x27, x28, [sp, 80]
	.cfi_restore 28
	.cfi_restore 27
	sdiv	x23, x23, x0
	sdiv	x22, x22, x0
	sdiv	x21, x21, x0
.L1072:
	ldr	x0, [sp, 120]
	ucvtf	s0, x0
	ldr	x0, [sp, 152]
	fdiv	s8, s8, s0
	stp	x23, x22, [x0, 8]
	str	x21, [x0, 24]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	str	s8, [x0]
	ldr	d8, [sp, 96]
	ldp	x29, x30, [sp], 240
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 72
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L1085:
	.cfi_def_cfa_offset 240
	.cfi_offset 19, -224
	.cfi_offset 20, -216
	.cfi_offset 21, -208
	.cfi_offset 22, -200
	.cfi_offset 23, -192
	.cfi_offset 24, -184
	.cfi_offset 25, -176
	.cfi_offset 26, -168
	.cfi_offset 27, -160
	.cfi_offset 28, -152
	.cfi_offset 29, -240
	.cfi_offset 30, -232
	.cfi_offset 72, -144
	mov	x19, 0
	mov	x5, 0
	b	.L1073
.L1084:
	.cfi_restore 19
	.cfi_restore 20
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 27
	.cfi_restore 28
	movi	v8.2s, #0
	mov	x21, 0
	mov	x22, 0
	mov	x23, 0
	b	.L1072
.L1104:
	.cfi_offset 19, -224
	.cfi_offset 20, -216
	.cfi_offset 25, -176
	.cfi_offset 26, -168
	.cfi_offset 27, -160
	.cfi_offset 28, -152
.LEHB71:
	bl	_ZSt17__throw_bad_allocv
.LEHE71:
.L1087:
	ldr	x1, [sp, 208]
	mov	x19, x0
	cbz	x1, .L1082
	mov	x0, x1
	bl	_ZdlPv
.L1082:
	ldr	x0, [sp, 176]
	cbz	x0, .L1083
	bl	_ZdlPv
.L1083:
	mov	x0, x19
.LEHB72:
	bl	_Unwind_Resume
.LEHE72:
.L1086:
	mov	x19, x0
	b	.L1082
	.cfi_endproc
.LFE10468:
	.section	.gcc_except_table
.LLSDA10468:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE10468-.LLSDACSB10468
.LLSDACSB10468:
	.uleb128 .LEHB68-.LFB10468
	.uleb128 .LEHE68-.LEHB68
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB69-.LFB10468
	.uleb128 .LEHE69-.LEHB69
	.uleb128 .L1086-.LFB10468
	.uleb128 0
	.uleb128 .LEHB70-.LFB10468
	.uleb128 .LEHE70-.LEHB70
	.uleb128 .L1087-.LFB10468
	.uleb128 0
	.uleb128 .LEHB71-.LFB10468
	.uleb128 .LEHE71-.LEHB71
	.uleb128 .L1086-.LFB10468
	.uleb128 0
	.uleb128 .LEHB72-.LFB10468
	.uleb128 .LEHE72-.LEHB72
	.uleb128 0
	.uleb128 0
.LLSDACSE10468:
	.text
	.size	_Z13run_pq_methodRKN3ann7PQIndexEPfS3_Pimmmm, .-_Z13run_pq_methodRKN3ann7PQIndexEPfS3_Pimmmm
	.section	.text._ZN3ann30sq8_search_rerank_u8simd_timedERKNS_8SQ8IndexEPKfS4_mmPNS_11QuantTimingE,"axG",@progbits,_ZN3ann30sq8_search_rerank_u8simd_timedERKNS_8SQ8IndexEPKfS4_mmPNS_11QuantTimingE,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN3ann30sq8_search_rerank_u8simd_timedERKNS_8SQ8IndexEPKfS4_mmPNS_11QuantTimingE
	.type	_ZN3ann30sq8_search_rerank_u8simd_timedERKNS_8SQ8IndexEPKfS4_mmPNS_11QuantTimingE, %function
_ZN3ann30sq8_search_rerank_u8simd_timedERKNS_8SQ8IndexEPKfS4_mmPNS_11QuantTimingE:
.LFB10427:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA10427
	stp	x29, x30, [sp, -224]!
	.cfi_def_cfa_offset 224
	.cfi_offset 29, -224
	.cfi_offset 30, -216
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	.cfi_offset 21, -192
	.cfi_offset 22, -184
	.cfi_offset 25, -160
	.cfi_offset 26, -152
	ldp	x25, x21, [x0]
	stp	x19, x20, [sp, 16]
	.cfi_offset 20, -200
	.cfi_offset 19, -208
	stp	x23, x24, [sp, 48]
	.cfi_offset 24, -168
	.cfi_offset 23, -176
	stp	x27, x28, [sp, 80]
	.cfi_offset 28, -136
	.cfi_offset 27, -144
	cmp	x25, x3
	stp	x1, x5, [sp, 120]
	csel	x25, x25, x3, ls
	cmp	x21, 0
	blt	.L1221
	mov	x24, x0
	mov	x22, x8
	mov	x19, x2
	mov	x26, x4
	mov	x20, 0
	beq	.L1107
	mov	x0, x21
.LEHB73:
	bl	_Znwm
.LEHE73:
	mov	x2, x21
	mov	x20, x0
	mov	w1, 0
	bl	memset
	ldr	x3, [x24, 8]
	cbz	x3, .L1107
	ldr	x5, [x24, 40]
	mov	x0, 0
	ldr	x4, [x24, 64]
	fmov	s3, 5.0e-1
	mov	w6, 255
	.p2align 3,,7
.L1112:
	ldr	s0, [x19, x0, lsl 2]
	mov	w2, 0
	ldr	s2, [x5, x0, lsl 2]
	ldr	s1, [x4, x0, lsl 2]
	fsub	s0, s0, s2
	fdiv	s0, s0, s1
	fadd	s0, s0, s3
	fcvtms	w1, s0
	tbnz	w1, #31, .L1111
	cmp	w1, 256
	and	w1, w1, 255
	csel	w2, w1, w6, lt
.L1111:
	strb	w2, [x20, x0]
	add	x0, x0, 1
	cmp	x0, x3
	bne	.L1112
.L1107:
	bl	_ZNSt6chrono3_V212system_clock3nowEv
	str	x0, [sp, 152]
	ldr	x6, [x24]
	stp	xzr, xzr, [sp, 192]
	str	xzr, [sp, 208]
	cbz	x6, .L1109
	add	x27, x24, 16
	sub	x21, x20, #16
	mov	x23, 0
	.p2align 3,,7
.L1110:
	ldr	x5, [x27]
	ldr	x2, [x24, 8]
	madd	x5, x2, x23, x5
	cmp	x2, 15
	bls	.L1169
	movi	v4.4s, 0
	sub	x3, x5, #16
	mov	x0, 16
	mov	v1.16b, v4.16b
	b	.L1116
	.p2align 2,,3
.L1170:
	mov	x0, x1
.L1116:
	ldr	q0, [x3, x0]
	add	x1, x0, 16
	ldr	q2, [x21, x0]
	dup	d3, v0.d[0]
	dup	d0, v0.d[1]
	dup	d5, v2.d[0]
	dup	d2, v2.d[1]
	umull	v3.8h, v3.8b, v5.8b
	umull	v0.8h, v0.8b, v2.8b
#APP
// 9533 "/usr/lib/gcc/aarch64-linux-gnu/10.3.1/include/arm_neon.h" 1
	uadalp v1.4s,v3.8h
// 0 "" 2
// 9533 "/usr/lib/gcc/aarch64-linux-gnu/10.3.1/include/arm_neon.h" 1
	uadalp v4.4s,v0.8h
// 0 "" 2
#NO_APP
	cmp	x2, x1
	bcs	.L1170
	add	v1.4s, v1.4s, v4.4s
.L1115:
	addv	s1, v1.4s
	umov	w1, v1.s[0]
	cmp	x2, x0
	bls	.L1117
	.p2align 3,,7
.L1118:
	ldrb	w4, [x5, x0]
	ldrb	w3, [x20, x0]
	add	x0, x0, 1
	madd	w1, w4, w3, w1
	cmp	x2, x0
	bne	.L1118
.L1117:
	ucvtf	s0, w1
	ldp	x0, x1, [sp, 192]
	fneg	s0, s0
	sub	x2, x1, x0
	cmp	x25, x2, asr 3
	bhi	.L1222
	ldr	s1, [x0]
	fcmpe	s0, s1
	bmi	.L1187
.L1122:
	add	x23, x23, 1
	cmp	x6, x23
	bhi	.L1110
.L1109:
	bl	_ZNSt6chrono3_V212system_clock3nowEv
	mov	x21, x0
	bl	_ZNSt6chrono3_V212system_clock3nowEv
	mov	x23, x0
	ldp	x0, x1, [sp, 192]
	stp	xzr, xzr, [x22]
	str	xzr, [x22, 16]
	cmp	x1, x0
	beq	.L1114
	str	d8, [sp, 96]
	.cfi_offset 72, -128
	fmov	s8, 1.0e+0
	.p2align 3,,7
.L1113:
	sub	x2, x1, x0
	ldr	w11, [x0, 4]
	cmp	x2, 8
	bgt	.L1223
.L1133:
	ldr	x0, [sp, 200]
	uxtw	x5, w11
	ldr	x2, [x24, 8]
	sub	x0, x0, #8
	str	x0, [sp, 200]
	ldr	x0, [sp, 120]
	mul	x5, x5, x2
	add	x5, x0, x5, lsl 2
	cmp	x2, 3
	bls	.L1179
	movi	v0.4s, 0
	mov	x4, x5
	mov	x3, x19
	mov	x0, 4
	b	.L1141
	.p2align 2,,3
.L1180:
	mov	x0, x1
.L1141:
	ldr	q2, [x4], 16
	add	x1, x0, 4
	ldr	q1, [x3], 16
	fmla	v0.4s, v2.4s, v1.4s
	cmp	x2, x1
	bcs	.L1180
.L1140:
	faddp	v0.4s, v0.4s, v0.4s
	faddp	v0.4s, v0.4s, v0.4s
	cmp	x2, x0
	bls	.L1142
	.p2align 3,,7
.L1143:
	ldr	s2, [x5, x0, lsl 2]
	ldr	s1, [x19, x0, lsl 2]
	add	x0, x0, 1
	fmadd	s0, s2, s1, s0
	cmp	x2, x0
	bne	.L1143
.L1142:
	ldp	x0, x1, [x22]
	fsub	s0, s8, s0
	sub	x2, x1, x0
	cmp	x26, x2, asr 3
	bhi	.L1224
	ldr	s1, [x0]
	fcmpe	s0, s1
	bmi	.L1190
.L1147:
	ldp	x0, x1, [sp, 192]
	cmp	x0, x1
	bne	.L1113
	ldr	d8, [sp, 96]
	.cfi_restore 72
.L1114:
	bl	_ZNSt6chrono3_V212system_clock3nowEv
	ldr	x5, [sp, 128]
	cbz	x5, .L1158
	mov	x1, 63439
	movk	x1, 0xe353, lsl 16
	ldr	x6, [sp, 152]
	movk	x1, 0x9ba5, lsl 32
	movk	x1, 0x20c4, lsl 48
	smulh	x4, x21, x1
	smulh	x3, x0, x1
	smulh	x2, x6, x1
	smulh	x1, x23, x1
	asr	x4, x4, 7
	asr	x3, x3, 7
	sub	x21, x4, x21, asr 63
	asr	x2, x2, 7
	sub	x0, x3, x0, asr 63
	asr	x1, x1, 7
	sub	x2, x2, x6, asr 63
	sub	x23, x1, x23, asr 63
	sub	x1, x21, x2
	sub	x0, x0, x23
	stp	x1, x0, [x5]
.L1158:
	ldr	x0, [sp, 192]
	cbz	x0, .L1159
	bl	_ZdlPv
.L1159:
	cbz	x20, .L1105
	mov	x0, x20
	bl	_ZdlPv
.L1105:
	mov	x0, x22
	ldp	x19, x20, [sp, 16]
	.cfi_restore 20
	.cfi_restore 19
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	.cfi_restore 24
	.cfi_restore 23
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	.cfi_restore 28
	.cfi_restore 27
	ldp	x29, x30, [sp], 224
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 21
	.cfi_restore 22
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L1224:
	.cfi_def_cfa_offset 224
	.cfi_offset 19, -208
	.cfi_offset 20, -200
	.cfi_offset 21, -192
	.cfi_offset 22, -184
	.cfi_offset 23, -176
	.cfi_offset 24, -168
	.cfi_offset 25, -160
	.cfi_offset 26, -152
	.cfi_offset 27, -144
	.cfi_offset 28, -136
	.cfi_offset 29, -224
	.cfi_offset 30, -216
	.cfi_offset 72, -128
	ldr	x2, [x22, 16]
	str	s0, [sp, 176]
	str	w11, [sp, 180]
	cmp	x1, x2
	beq	.L1145
	ldr	x2, [sp, 176]
	str	x2, [x1], 8
	str	x1, [x22, 8]
.L1146:
	ldr	x3, [x1, -8]
	sub	x2, x1, x0
	asr	x1, x2, 3
	mov	x2, 0
	sub	x1, x1, #1
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	b	.L1147
	.p2align 2,,3
.L1222:
	.cfi_restore 72
	ldr	x2, [sp, 208]
	str	s0, [sp, 160]
	str	w23, [sp, 164]
	cmp	x1, x2
	beq	.L1120
	ldr	x2, [sp, 160]
	str	x2, [x1], 8
	str	x1, [sp, 200]
.L1121:
	ldr	x3, [x1, -8]
	sub	x2, x1, x0
	asr	x1, x2, 3
	mov	x2, 0
	sub	x1, x1, #1
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldr	x6, [x24]
	b	.L1122
	.p2align 2,,3
.L1223:
	.cfi_offset 72, -128
	sub	x2, x1, #8
	ldr	w3, [x1, -8]
	sub	x2, x2, x0
	ldr	s0, [x0]
	ldr	w4, [x1, -4]
	asr	x9, x2, 3
	bfi	x28, x3, 0, 32
	sub	x7, x9, #1
	str	s0, [x1, -8]
	str	w11, [x1, -4]
	bfi	x28, x4, 32, 32
	add	x7, x7, x7, lsr 63
	asr	x7, x7, 1
	cmp	x2, 16
	ble	.L1175
	mov	x2, 0
	b	.L1138
	.p2align 2,,3
.L1177:
	mov	w3, w4
.L1137:
	lsl	x2, x2, 3
	add	x4, x0, x2
	str	s0, [x0, x2]
	str	w3, [x4, 4]
	cmp	x7, x1
	ble	.L1134
.L1178:
	mov	x2, x1
.L1138:
	add	x3, x2, 1
	lsl	x5, x3, 1
	lsl	x3, x3, 4
	sub	x1, x5, #1
	add	x8, x0, x3
	lsl	x4, x1, 3
	ldr	s1, [x0, x3]
	add	x6, x0, x4
	ldr	s0, [x0, x4]
	fcmpe	s1, s0
	bmi	.L1189
	ldr	w3, [x8, 4]
	bgt	.L1176
	ldr	w4, [x6, 4]
	cmp	w4, w3
	bhi	.L1177
.L1176:
	fmov	s0, s1
	lsl	x2, x2, 3
	add	x4, x0, x2
	mov	x1, x5
	str	s0, [x0, x2]
	str	w3, [x4, 4]
	cmp	x7, x1
	bgt	.L1178
.L1134:
	tbnz	x9, 0, .L1139
	sub	x9, x9, #2
	add	x9, x9, x9, lsr 63
	cmp	x1, x9, asr 1
	bne	.L1139
	lsl	x3, x1, 1
	lsl	x2, x1, 3
	add	x1, x3, 1
	add	x4, x0, x2
	lsl	x3, x1, 3
	add	x5, x0, x3
	ldr	s0, [x0, x3]
	ldr	w3, [x5, 4]
	str	s0, [x0, x2]
	str	w3, [x4, 4]
	.p2align 3,,7
.L1139:
	mov	x3, x28
	mov	x2, 0
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	b	.L1133
	.p2align 2,,3
.L1189:
	ldr	w3, [x6, 4]
	b	.L1137
	.p2align 2,,3
.L1187:
	.cfi_restore 72
	ldr	x2, [sp, 208]
	str	s0, [sp, 168]
	str	w23, [sp, 172]
	cmp	x1, x2
	beq	.L1124
	ldr	x2, [sp, 168]
	str	x2, [x1], 8
	str	x1, [sp, 200]
.L1125:
	ldr	x3, [x1, -8]
	sub	x2, x1, x0
	asr	x1, x2, 3
	mov	x2, 0
	sub	x1, x1, #1
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldp	x0, x1, [sp, 192]
	sub	x2, x1, x0
	cmp	x2, 8
	bgt	.L1225
.L1126:
	sub	x1, x1, #8
	str	x1, [sp, 200]
	ldr	x6, [x24]
	b	.L1122
	.p2align 2,,3
.L1190:
	.cfi_offset 72, -128
	ldr	x2, [x22, 16]
	str	s0, [sp, 184]
	str	w11, [sp, 188]
	cmp	x1, x2
	beq	.L1149
	ldr	x2, [sp, 184]
	str	x2, [x1], 8
	str	x1, [x22, 8]
.L1150:
	ldr	x3, [x1, -8]
	sub	x2, x1, x0
	asr	x1, x2, 3
	mov	x2, 0
	sub	x1, x1, #1
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldp	x0, x1, [x22]
	sub	x2, x1, x0
	cmp	x2, 8
	bgt	.L1226
.L1151:
	sub	x1, x1, #8
	str	x1, [x22, 8]
	b	.L1147
	.p2align 2,,3
.L1179:
	movi	v0.4s, 0
	mov	x0, 0
	b	.L1140
	.p2align 2,,3
.L1169:
	.cfi_restore 72
	movi	v1.4s, 0
	mov	x0, 0
	b	.L1115
.L1226:
	.cfi_offset 72, -128
	sub	x3, x1, #8
	ldr	w4, [x1, -8]
	sub	x3, x3, x0
	ldr	w5, [x1, -4]
	ldr	x6, [sp, 144]
	asr	x9, x3, 3
	sub	x2, x9, #1
	ldr	s0, [x0]
	bfi	x6, x4, 0, 32
	add	x2, x2, x2, lsr 63
	ldr	w4, [x0, 4]
	bfi	x6, x5, 32, 32
	str	s0, [x1, -8]
	str	w4, [x1, -4]
	str	x6, [sp, 144]
	asr	x6, x2, 1
	cmp	x3, 16
	ble	.L1181
	mov	x2, 0
	b	.L1156
.L1183:
	mov	w3, w4
	.p2align 3,,7
.L1155:
	lsl	x2, x2, 3
	add	x4, x0, x2
	str	s0, [x0, x2]
	str	w3, [x4, 4]
	cmp	x6, x1
	ble	.L1152
.L1184:
	mov	x2, x1
.L1156:
	add	x3, x2, 1
	lsl	x5, x3, 1
	lsl	x3, x3, 4
	sub	x1, x5, #1
	add	x8, x0, x3
	lsl	x4, x1, 3
	ldr	s1, [x0, x3]
	add	x7, x0, x4
	ldr	s0, [x0, x4]
	fcmpe	s1, s0
	bmi	.L1191
	ldr	w3, [x8, 4]
	bgt	.L1182
	ldr	w4, [x7, 4]
	cmp	w4, w3
	bhi	.L1183
.L1182:
	fmov	s0, s1
	lsl	x2, x2, 3
	add	x4, x0, x2
	mov	x1, x5
	str	s0, [x0, x2]
	str	w3, [x4, 4]
	cmp	x6, x1
	bgt	.L1184
.L1152:
	tbnz	x9, 0, .L1157
.L1229:
	sub	x9, x9, #2
	add	x9, x9, x9, lsr 63
	cmp	x1, x9, asr 1
	beq	.L1227
.L1157:
	ldr	x3, [sp, 144]
	mov	x2, 0
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldr	x1, [x22, 8]
	b	.L1151
	.p2align 2,,3
.L1191:
	ldr	w3, [x7, 4]
	b	.L1155
.L1225:
	.cfi_restore 72
	sub	x3, x1, #8
	ldr	w4, [x1, -8]
	sub	x3, x3, x0
	ldr	w5, [x1, -4]
	ldr	x6, [sp, 136]
	asr	x9, x3, 3
	sub	x2, x9, #1
	ldr	s0, [x0]
	bfi	x6, x4, 0, 32
	add	x2, x2, x2, lsr 63
	ldr	w4, [x0, 4]
	bfi	x6, x5, 32, 32
	str	s0, [x1, -8]
	str	w4, [x1, -4]
	str	x6, [sp, 136]
	asr	x6, x2, 1
	cmp	x3, 16
	ble	.L1171
	mov	x2, 0
	b	.L1131
.L1173:
	mov	w3, w4
	.p2align 3,,7
.L1130:
	lsl	x2, x2, 3
	add	x4, x0, x2
	str	s0, [x0, x2]
	str	w3, [x4, 4]
	cmp	x1, x6
	bge	.L1127
.L1174:
	mov	x2, x1
.L1131:
	add	x3, x2, 1
	lsl	x5, x3, 1
	lsl	x3, x3, 4
	sub	x1, x5, #1
	add	x8, x0, x3
	lsl	x4, x1, 3
	ldr	s1, [x0, x3]
	add	x7, x0, x4
	ldr	s0, [x0, x4]
	fcmpe	s1, s0
	bmi	.L1188
	ldr	w3, [x8, 4]
	bgt	.L1172
	ldr	w4, [x7, 4]
	cmp	w4, w3
	bhi	.L1173
.L1172:
	fmov	s0, s1
	lsl	x2, x2, 3
	add	x4, x0, x2
	mov	x1, x5
	str	s0, [x0, x2]
	str	w3, [x4, 4]
	cmp	x1, x6
	blt	.L1174
.L1127:
	tbnz	x9, 0, .L1132
.L1230:
	sub	x9, x9, #2
	add	x9, x9, x9, lsr 63
	cmp	x1, x9, asr 1
	beq	.L1228
.L1132:
	ldr	x3, [sp, 136]
	mov	x2, 0
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldr	x1, [sp, 200]
	b	.L1126
	.p2align 2,,3
.L1188:
	ldr	w3, [x7, 4]
	b	.L1130
.L1120:
	add	x2, sp, 160
	add	x0, sp, 192
.LEHB74:
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE74:
	ldp	x0, x1, [sp, 192]
	b	.L1121
.L1145:
	.cfi_offset 72, -128
	add	x2, sp, 176
	mov	x0, x22
.LEHB75:
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	ldp	x0, x1, [x22]
	b	.L1146
.L1149:
	add	x2, sp, 184
	mov	x0, x22
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE75:
	ldp	x0, x1, [x22]
	b	.L1150
.L1124:
	.cfi_restore 72
	add	x2, sp, 168
	add	x0, sp, 192
.LEHB76:
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE76:
	ldp	x0, x1, [sp, 192]
	b	.L1125
.L1175:
	.cfi_offset 72, -128
	mov	x1, 0
	b	.L1134
.L1227:
	lsl	x3, x1, 1
	lsl	x2, x1, 3
	add	x1, x3, 1
	add	x4, x0, x2
	lsl	x3, x1, 3
	add	x5, x0, x3
	ldr	s0, [x0, x3]
	ldr	w3, [x5, 4]
	str	s0, [x0, x2]
	mov	x2, 0
	str	w3, [x4, 4]
	ldr	x3, [sp, 144]
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldr	x1, [x22, 8]
	b	.L1151
.L1228:
	.cfi_restore 72
	lsl	x3, x1, 1
	lsl	x2, x1, 3
	add	x1, x3, 1
	add	x4, x0, x2
	lsl	x3, x1, 3
	add	x5, x0, x3
	ldr	s0, [x0, x3]
	ldr	w3, [x5, 4]
	str	s0, [x0, x2]
	mov	x2, 0
	str	w3, [x4, 4]
	ldr	x3, [sp, 136]
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldr	x1, [sp, 200]
	b	.L1126
.L1181:
	.cfi_offset 72, -128
	mov	x1, 0
	tbnz	x9, 0, .L1157
	b	.L1229
.L1171:
	.cfi_restore 72
	mov	x1, 0
	tbnz	x9, 0, .L1132
	b	.L1230
.L1221:
	adrp	x0, .LC37
	add	x0, x0, :lo12:.LC37
	str	d8, [sp, 96]
	.cfi_remember_state
	.cfi_offset 72, -128
.LEHB77:
	bl	_ZSt20__throw_length_errorPKc
.L1185:
	.cfi_restore_state
	mov	x19, x0
	str	d8, [sp, 96]
	.cfi_offset 72, -128
.L1163:
	ldr	x0, [sp, 192]
	cbz	x0, .L1164
	bl	_ZdlPv
.L1164:
	cbz	x20, .L1165
	mov	x0, x20
	bl	_ZdlPv
.L1165:
	mov	x0, x19
	bl	_Unwind_Resume
.LEHE77:
.L1186:
	ldr	x1, [x22]
	mov	x19, x0
	cbz	x1, .L1163
	mov	x0, x1
	bl	_ZdlPv
	b	.L1163
	.cfi_endproc
.LFE10427:
	.section	.gcc_except_table
.LLSDA10427:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE10427-.LLSDACSB10427
.LLSDACSB10427:
	.uleb128 .LEHB73-.LFB10427
	.uleb128 .LEHE73-.LEHB73
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB74-.LFB10427
	.uleb128 .LEHE74-.LEHB74
	.uleb128 .L1185-.LFB10427
	.uleb128 0
	.uleb128 .LEHB75-.LFB10427
	.uleb128 .LEHE75-.LEHB75
	.uleb128 .L1186-.LFB10427
	.uleb128 0
	.uleb128 .LEHB76-.LFB10427
	.uleb128 .LEHE76-.LEHB76
	.uleb128 .L1185-.LFB10427
	.uleb128 0
	.uleb128 .LEHB77-.LFB10427
	.uleb128 .LEHE77-.LEHB77
	.uleb128 0
	.uleb128 0
.LLSDACSE10427:
	.section	.text._ZN3ann30sq8_search_rerank_u8simd_timedERKNS_8SQ8IndexEPKfS4_mmPNS_11QuantTimingE,"axG",@progbits,_ZN3ann30sq8_search_rerank_u8simd_timedERKNS_8SQ8IndexEPKfS4_mmPNS_11QuantTimingE,comdat
	.size	_ZN3ann30sq8_search_rerank_u8simd_timedERKNS_8SQ8IndexEPKfS4_mmPNS_11QuantTimingE, .-_ZN3ann30sq8_search_rerank_u8simd_timedERKNS_8SQ8IndexEPKfS4_mmPNS_11QuantTimingE
	.text
	.align	2
	.p2align 4,,11
	.global	_Z21run_sq8_u8simd_methodRKN3ann8SQ8IndexEPfS3_Pimmmm
	.type	_Z21run_sq8_u8simd_methodRKN3ann8SQ8IndexEPfS3_Pimmmm, %function
_Z21run_sq8_u8simd_methodRKN3ann8SQ8IndexEPfS3_Pimmmm:
.LFB10467:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA10467
	stp	x29, x30, [sp, -240]!
	.cfi_def_cfa_offset 240
	.cfi_offset 29, -240
	.cfi_offset 30, -232
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	stp	x5, x1, [sp, 120]
	stp	x2, x3, [sp, 136]
	str	x8, [sp, 152]
	str	d8, [sp, 96]
	.cfi_offset 21, -208
	.cfi_offset 22, -200
	.cfi_offset 23, -192
	.cfi_offset 24, -184
	.cfi_offset 72, -144
	cbz	x5, .L1244
	movi	v8.2s, #0
	mov	x24, x0
	stp	x25, x26, [sp, 64]
	.cfi_offset 26, -168
	.cfi_offset 25, -176
	mov	x26, 16960
	mov	x25, x7
	stp	x27, x28, [sp, 80]
	.cfi_offset 28, -152
	.cfi_offset 27, -160
	mov	x27, x4
	mov	x28, x6
	mov	x21, 0
	mov	x22, 0
	mov	x23, 0
	movk	x26, 0xf, lsl 16
	stp	x19, x20, [sp, 16]
	.cfi_offset 20, -216
	.cfi_offset 19, -224
	mov	x20, 0
	.p2align 3,,7
.L1239:
	mov	x1, 0
	add	x0, sp, 208
	stp	xzr, xzr, [sp, 160]
	bl	gettimeofday
	ldr	x2, [x24, 8]
	mov	x3, x28
	ldp	x1, x0, [sp, 128]
	add	x8, sp, 176
	ldp	x19, x6, [sp, 208]
	mul	x2, x20, x2
	add	x5, sp, 160
	mov	x4, x25
	add	x2, x0, x2, lsl 2
	mov	x0, x24
	madd	x19, x19, x26, x6
.LEHB78:
	bl	_ZN3ann30sq8_search_rerank_u8simd_timedERKNS_8SQ8IndexEPKfS4_mmPNS_11QuantTimingE
.LEHE78:
	mov	x1, 0
	add	x0, sp, 208
	bl	gettimeofday
	str	xzr, [sp, 224]
	ldp	x0, x1, [sp, 208]
	stp	xzr, xzr, [sp, 208]
	ldr	x2, [sp, 160]
	ldr	x3, [sp, 176]
	madd	x0, x0, x26, x1
	ldr	x1, [sp, 168]
	sub	x0, x0, x19
	add	x23, x23, x0
	add	x22, x22, x2
	ldr	x0, [sp, 184]
	add	x21, x21, x1
	subs	x19, x0, x3
	beq	.L1245
	mov	x0, 9223372036854775800
	cmp	x19, x0
	bhi	.L1264
	mov	x0, x19
.LEHB79:
	bl	_Znwm
.LEHE79:
	mov	x5, x0
	ldp	x3, x0, [sp, 176]
.L1233:
	add	x19, x5, x19
	stp	x5, x5, [sp, 208]
	str	x19, [sp, 224]
	cmp	x0, x3
	beq	.L1235
	sub	x0, x0, x3
	mov	x1, 0
	.p2align 3,,7
.L1236:
	ldr	x2, [x3, x1]
	str	x2, [x5, x1]
	add	x1, x1, 8
	cmp	x1, x0
	bne	.L1236
	add	x5, x5, x1
.L1235:
	ldr	x1, [sp, 144]
	mov	x4, x25
	mov	x3, x20
	mov	x2, x27
	add	x0, sp, 208
	str	x5, [sp, 216]
.LEHB80:
	bl	_Z11calc_recallSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EESt4lessIS1_EEPimmm
.LEHE80:
	ldr	x0, [sp, 208]
	fadd	s8, s8, s0
	cbz	x0, .L1237
	bl	_ZdlPv
.L1237:
	ldr	x0, [sp, 176]
	cbz	x0, .L1238
	bl	_ZdlPv
.L1238:
	ldr	x0, [sp, 120]
	add	x20, x20, 1
	cmp	x0, x20
	bne	.L1239
	ldp	x19, x20, [sp, 16]
	.cfi_restore 20
	.cfi_restore 19
	ldp	x25, x26, [sp, 64]
	.cfi_restore 26
	.cfi_restore 25
	ldp	x27, x28, [sp, 80]
	.cfi_restore 28
	.cfi_restore 27
	sdiv	x23, x23, x0
	sdiv	x22, x22, x0
	sdiv	x21, x21, x0
.L1232:
	ldr	x0, [sp, 120]
	ucvtf	s0, x0
	ldr	x0, [sp, 152]
	fdiv	s8, s8, s0
	stp	x23, x22, [x0, 8]
	str	x21, [x0, 24]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	str	s8, [x0]
	ldr	d8, [sp, 96]
	ldp	x29, x30, [sp], 240
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 72
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L1245:
	.cfi_def_cfa_offset 240
	.cfi_offset 19, -224
	.cfi_offset 20, -216
	.cfi_offset 21, -208
	.cfi_offset 22, -200
	.cfi_offset 23, -192
	.cfi_offset 24, -184
	.cfi_offset 25, -176
	.cfi_offset 26, -168
	.cfi_offset 27, -160
	.cfi_offset 28, -152
	.cfi_offset 29, -240
	.cfi_offset 30, -232
	.cfi_offset 72, -144
	mov	x19, 0
	mov	x5, 0
	b	.L1233
.L1244:
	.cfi_restore 19
	.cfi_restore 20
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 27
	.cfi_restore 28
	movi	v8.2s, #0
	mov	x21, 0
	mov	x22, 0
	mov	x23, 0
	b	.L1232
.L1264:
	.cfi_offset 19, -224
	.cfi_offset 20, -216
	.cfi_offset 25, -176
	.cfi_offset 26, -168
	.cfi_offset 27, -160
	.cfi_offset 28, -152
.LEHB81:
	bl	_ZSt17__throw_bad_allocv
.LEHE81:
.L1247:
	ldr	x1, [sp, 208]
	mov	x19, x0
	cbz	x1, .L1242
	mov	x0, x1
	bl	_ZdlPv
.L1242:
	ldr	x0, [sp, 176]
	cbz	x0, .L1243
	bl	_ZdlPv
.L1243:
	mov	x0, x19
.LEHB82:
	bl	_Unwind_Resume
.LEHE82:
.L1246:
	mov	x19, x0
	b	.L1242
	.cfi_endproc
.LFE10467:
	.section	.gcc_except_table
.LLSDA10467:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE10467-.LLSDACSB10467
.LLSDACSB10467:
	.uleb128 .LEHB78-.LFB10467
	.uleb128 .LEHE78-.LEHB78
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB79-.LFB10467
	.uleb128 .LEHE79-.LEHB79
	.uleb128 .L1246-.LFB10467
	.uleb128 0
	.uleb128 .LEHB80-.LFB10467
	.uleb128 .LEHE80-.LEHB80
	.uleb128 .L1247-.LFB10467
	.uleb128 0
	.uleb128 .LEHB81-.LFB10467
	.uleb128 .LEHE81-.LEHB81
	.uleb128 .L1246-.LFB10467
	.uleb128 0
	.uleb128 .LEHB82-.LFB10467
	.uleb128 .LEHE82-.LEHB82
	.uleb128 0
	.uleb128 0
.LLSDACSE10467:
	.text
	.size	_Z21run_sq8_u8simd_methodRKN3ann8SQ8IndexEPfS3_Pimmmm, .-_Z21run_sq8_u8simd_methodRKN3ann8SQ8IndexEPfS3_Pimmmm
	.section	.text._ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRKS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_,"axG",@progbits,_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRKS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRKS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.type	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRKS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_, %function
_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRKS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_:
.LFB11656:
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	ldp	x24, x23, [x0]
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	mov	x20, x0
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	sub	x0, x23, x24
	str	x27, [sp, 80]
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	.cfi_offset 27, -16
	mov	x27, x2
	asr	x0, x0, 3
	mov	x2, 1152921504606846975
	cmp	x0, x2
	beq	.L1283
	cmp	x0, 0
	mov	x19, x1
	sub	x26, x1, x24
	csinc	x1, x0, xzr, ne
	adds	x1, x1, x0
	bcs	.L1276
	cbnz	x1, .L1270
	mov	x25, 8
	mov	x22, 0
	mov	x21, 0
.L1275:
	ldr	x0, [x27]
	str	x0, [x21, x26]
	cmp	x19, x24
	beq	.L1271
	mov	x4, x21
	mov	x3, x24
	.p2align 3,,7
.L1272:
	ldr	x5, [x3], 8
	str	x5, [x4], 8
	cmp	x3, x19
	bne	.L1272
	add	x26, x26, 8
	add	x25, x21, x26
.L1271:
	cmp	x19, x23
	beq	.L1273
	sub	x2, x23, x19
	mov	x0, x25
	mov	x1, x19
	add	x25, x25, x2
	bl	memcpy
.L1273:
	cbz	x24, .L1274
	mov	x0, x24
	bl	_ZdlPv
.L1274:
	ldp	x23, x24, [sp, 48]
	ldr	x27, [sp, 80]
	stp	x21, x25, [x20]
	str	x22, [x20, 16]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L1276:
	.cfi_restore_state
	mov	x22, 9223372036854775800
.L1269:
	mov	x0, x22
	bl	_Znwm
	mov	x21, x0
	add	x22, x0, x22
	add	x25, x0, 8
	b	.L1275
.L1270:
	cmp	x1, x2
	csel	x1, x1, x2, ls
	lsl	x22, x1, 3
	b	.L1269
.L1283:
	adrp	x0, .LC42
	add	x0, x0, :lo12:.LC42
	bl	_ZSt20__throw_length_errorPKc
	.cfi_endproc
.LFE11656:
	.size	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRKS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_, .-_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRKS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.section	.rodata._ZN3ann18flat_search_methodEPKfS1_mmmNS_12SearchMethodEm.str1.8,"aMS",@progbits,1
	.align	3
.LC43:
	.string	"vector::reserve"
	.section	.text._ZN3ann18flat_search_methodEPKfS1_mmmNS_12SearchMethodEm,"axG",@progbits,_ZN3ann18flat_search_methodEPKfS1_mmmNS_12SearchMethodEm,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN3ann18flat_search_methodEPKfS1_mmmNS_12SearchMethodEm
	.type	_ZN3ann18flat_search_methodEPKfS1_mmmNS_12SearchMethodEm, %function
_ZN3ann18flat_search_methodEPKfS1_mmmNS_12SearchMethodEm:
.LFB10412:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA10412
	stp	x29, x30, [sp, -192]!
	.cfi_def_cfa_offset 192
	.cfi_offset 29, -192
	.cfi_offset 30, -184
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -176
	.cfi_offset 20, -168
	mov	x19, x0
	mov	x20, x3
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -160
	.cfi_offset 22, -152
	mov	x22, x1
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -144
	.cfi_offset 24, -136
	mov	x24, x8
	mov	x23, x2
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -128
	.cfi_offset 26, -120
	mov	x26, x4
	stp	x27, x28, [sp, 80]
	.cfi_offset 27, -112
	.cfi_offset 28, -104
	mov	x27, x6
	cmp	w5, 7
	beq	.L1402
	stp	xzr, xzr, [sp, 152]
	str	xzr, [sp, 168]
	cbz	x2, .L1348
	sub	w0, w5, #6
	lsl	x28, x3, 2
	cmp	w0, 1
	mov	w25, w5
	cset	w1, ls
	cmp	x6, 0
	mul	x2, x6, x28
	cset	w0, ne
	and	w0, w1, w0
	mov	x21, 0
	str	w0, [sp, 108]
	str	x2, [sp, 112]
	b	.L1342
	.p2align 2,,3
.L1328:
	ldr	s1, [x0]
	fcmpe	s0, s1
	bmi	.L1359
.L1331:
	add	x21, x21, 1
	add	x19, x19, x28
	cmp	x23, x21
	beq	.L1403
.L1342:
	ldr	w0, [sp, 108]
	cbnz	w0, .L1404
.L1327:
	mov	x2, x20
	mov	x1, x22
	mov	x0, x19
	mov	w3, w25
	bl	_ZN3ann11ip_distanceEPKfS1_mNS_12SearchMethodE
	ldp	x0, x1, [sp, 152]
	sub	x2, x1, x0
	cmp	x26, x2, asr 3
	bls	.L1328
	ldr	x2, [sp, 168]
	str	s0, [sp, 136]
	str	w21, [sp, 140]
	cmp	x1, x2
	beq	.L1329
	ldr	x2, [sp, 136]
	str	x2, [x1], 8
	str	x1, [sp, 160]
.L1330:
	ldr	x3, [x1, -8]
	sub	x2, x1, x0
	add	x21, x21, 1
	add	x19, x19, x28
	asr	x1, x2, 3
	mov	x2, 0
	sub	x1, x1, #1
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	cmp	x23, x21
	bne	.L1342
.L1403:
	ldp	x2, x1, [sp, 152]
	ldr	x0, [sp, 168]
.L1326:
	stp	x2, x1, [x24]
	str	x0, [x24, 16]
.L1284:
	mov	x0, x24
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 192
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L1404:
	.cfi_restore_state
	add	x0, x27, x21
	cmp	x23, x0
	bls	.L1327
	ldr	x0, [sp, 112]
	add	x0, x0, x19
	prfm	PLDL3KEEP, [x0]
	b	.L1327
	.p2align 2,,3
.L1359:
	ldr	x2, [sp, 168]
	str	s0, [sp, 144]
	str	w21, [sp, 148]
	cmp	x1, x2
	beq	.L1333
	ldr	x2, [sp, 144]
	str	x2, [x1], 8
	str	x1, [sp, 160]
.L1334:
	ldr	x3, [x1, -8]
	sub	x2, x1, x0
	asr	x1, x2, 3
	mov	x2, 0
	sub	x1, x1, #1
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldp	x0, x1, [sp, 152]
	sub	x2, x1, x0
	cmp	x2, 8
	bgt	.L1405
.L1335:
	sub	x1, x1, #8
	str	x1, [sp, 160]
	b	.L1331
	.p2align 2,,3
.L1405:
	sub	x2, x1, #8
	ldr	w3, [x1, -8]
	sub	x2, x2, x0
	ldr	w4, [x1, -4]
	ldr	x5, [sp, 120]
	asr	x8, x2, 3
	sub	x6, x8, #1
	ldr	s0, [x0]
	bfi	x5, x3, 0, 32
	add	x6, x6, x6, lsr 63
	ldr	w3, [x0, 4]
	bfi	x5, x4, 32, 32
	str	s0, [x1, -8]
	str	w3, [x1, -4]
	asr	x6, x6, 1
	str	x5, [sp, 120]
	cmp	x2, 16
	ble	.L1349
	mov	x3, 0
	b	.L1340
	.p2align 2,,3
.L1351:
	mov	w4, w2
.L1339:
	lsl	x2, x3, 3
	add	x3, x0, x2
	str	s0, [x0, x2]
	str	w4, [x3, 4]
	cmp	x6, x1
	ble	.L1336
.L1352:
	mov	x3, x1
.L1340:
	add	x2, x3, 1
	lsl	x5, x2, 1
	lsl	x2, x2, 4
	sub	x1, x5, #1
	add	x7, x0, x2
	lsl	x4, x1, 3
	ldr	s1, [x0, x2]
	add	x2, x0, x4
	ldr	s0, [x0, x4]
	fcmpe	s1, s0
	bmi	.L1360
	ldr	w4, [x7, 4]
	bgt	.L1350
	ldr	w2, [x2, 4]
	cmp	w2, w4
	bhi	.L1351
.L1350:
	fmov	s0, s1
	lsl	x2, x3, 3
	add	x3, x0, x2
	mov	x1, x5
	str	s0, [x0, x2]
	str	w4, [x3, 4]
	cmp	x6, x1
	bgt	.L1352
.L1336:
	tbnz	x8, 0, .L1341
	sub	x8, x8, #2
	add	x8, x8, x8, lsr 63
	cmp	x1, x8, asr 1
	beq	.L1406
.L1341:
	ldr	x3, [sp, 120]
	mov	x2, 0
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldr	x1, [sp, 160]
	b	.L1335
	.p2align 2,,3
.L1360:
	ldr	w4, [x2, 4]
	b	.L1339
	.p2align 2,,3
.L1329:
	add	x2, sp, 136
	add	x0, sp, 152
.LEHB83:
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	ldp	x0, x1, [sp, 152]
	b	.L1330
	.p2align 2,,3
.L1333:
	add	x2, sp, 144
	add	x0, sp, 152
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE83:
	ldp	x0, x1, [sp, 152]
	b	.L1334
	.p2align 2,,3
.L1402:
	stp	x4, xzr, [sp, 152]
	mov	x0, 1152921504606846975
	stp	xzr, xzr, [sp, 168]
	str	xzr, [sp, 184]
	cmp	x4, x0
	bhi	.L1407
	cbz	x4, .L1287
	lsl	x26, x4, 3
	mov	x0, x26
.LEHB84:
	bl	_Znwm
.LEHE84:
	mov	x21, x0
	ldp	x0, x4, [sp, 168]
	cmp	x0, x4
	beq	.L1291
	sub	x4, x4, x0
	mov	x1, x21
	add	x4, x21, x4
	mov	x2, x0
	.p2align 3,,7
.L1292:
	ldr	x3, [x2], 8
	str	x3, [x1], 8
	cmp	x1, x4
	bne	.L1292
.L1291:
	cbz	x0, .L1290
	bl	_ZdlPv
.L1290:
	add	x26, x21, x26
	stp	x21, x21, [sp, 168]
	str	x26, [sp, 184]
.L1287:
	cbz	x23, .L1408
	lsl	x25, x20, 2
	mov	x21, 0
	ldp	x0, x8, [sp, 168]
	mul	x26, x27, x25
	ldr	x7, [sp, 152]
	.p2align 3,,7
.L1317:
	cbz	x27, .L1298
	add	x1, x27, x21
	cmp	x23, x1
	bls	.L1298
	prfm	PLDL3KEEP, [x26, x19]
.L1298:
	cmp	x20, 15
	bls	.L1346
	movi	v1.4s, 0
	add	x4, x22, 48
	mov	x3, x19
	mov	x2, 16
	mov	v2.16b, v1.16b
	mov	v3.16b, v1.16b
	mov	v0.16b, v1.16b
	b	.L1300
	.p2align 2,,3
.L1347:
	mov	x2, x5
.L1300:
	ldp	q18, q16, [x4, -48]
	add	x5, x2, 16
	ldr	q6, [x4, -16]
	ldp	q19, q17, [x3]
	ldp	q7, q5, [x3, 32]
	add	x3, x3, 64
	ldr	q4, [x4], 64
	fmla	v0.4s, v19.4s, v18.4s
	fmla	v3.4s, v17.4s, v16.4s
	fmla	v2.4s, v7.4s, v6.4s
	fmla	v1.4s, v5.4s, v4.4s
	cmp	x20, x5
	bcs	.L1347
	fadd	v0.4s, v0.4s, v3.4s
	fadd	v2.4s, v2.4s, v1.4s
	fadd	v0.4s, v0.4s, v2.4s
.L1299:
	faddp	v0.4s, v0.4s, v0.4s
	faddp	v0.4s, v0.4s, v0.4s
	cmp	x20, x2
	bls	.L1301
	.p2align 3,,7
.L1302:
	ldr	s2, [x19, x2, lsl 2]
	ldr	s1, [x22, x2, lsl 2]
	add	x2, x2, 1
	fmadd	s0, s2, s1, s0
	cmp	x20, x2
	bne	.L1302
.L1301:
	cbz	x7, .L1304
	sub	x3, x8, x0
	fmov	s1, 1.0e+0
	asr	x6, x3, 3
	fsub	s0, s1, s0
	cmp	x7, x6
	bhi	.L1409
	ldr	x2, [sp, 160]
	lsl	x2, x2, 3
	add	x1, x0, x2
	ldr	s1, [x0, x2]
	fcmpe	s0, s1
	bge	.L1304
	str	s0, [x0, x2]
	str	w21, [x1, 4]
	str	xzr, [sp, 160]
	cmp	x3, 8
	bls	.L1304
	mov	w1, 0
	mov	x5, 0
	mov	x2, 1
	.p2align 3,,7
.L1315:
	lsl	x4, x5, 3
	lsl	x3, x2, 3
	ldr	s1, [x0, x4]
	ldr	s0, [x0, x3]
	fcmpe	s1, s0
	bmi	.L1358
.L1313:
	add	x2, x2, 1
	cmp	x6, x2
	bhi	.L1315
	cbz	w1, .L1304
.L1399:
	str	x5, [sp, 160]
	.p2align 3,,7
.L1304:
	add	x21, x21, 1
	add	x19, x19, x25
	cmp	x23, x21
	bne	.L1317
.L1316:
	stp	xzr, xzr, [x24]
	mov	x3, 0
	mov	x1, 0
	str	xzr, [x24, 16]
	mov	x19, 0
	cmp	x8, x0
	bne	.L1320
	b	.L1295
	.p2align 2,,3
.L1410:
	ldr	x0, [x0, x19, lsl 3]
	str	x0, [x1], 8
	str	x1, [x24, 8]
.L1319:
	ldr	x0, [x24]
	mov	x2, 0
	ldr	x3, [x1, -8]
	sub	x1, x1, x0
	add	x19, x19, 1
	asr	x1, x1, 3
	sub	x1, x1, #1
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldp	x0, x1, [sp, 168]
	sub	x1, x1, x0
	cmp	x19, x1, asr 3
	bcs	.L1295
	ldp	x1, x3, [x24, 8]
.L1320:
	add	x2, x0, x19, lsl 3
	cmp	x1, x3
	bne	.L1410
	mov	x0, x24
.LEHB85:
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRKS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE85:
	ldr	x1, [x24, 8]
	b	.L1319
.L1406:
	lsl	x3, x1, 1
	lsl	x2, x1, 3
	add	x1, x3, 1
	add	x4, x0, x2
	lsl	x3, x1, 3
	add	x5, x0, x3
	ldr	s0, [x0, x3]
	ldr	w3, [x5, 4]
	str	s0, [x0, x2]
	str	w3, [x4, 4]
	b	.L1341
	.p2align 2,,3
.L1358:
	mov	x5, x2
	mov	w1, 1
	b	.L1313
	.p2align 2,,3
.L1409:
	ldr	x1, [sp, 184]
	str	w21, [sp, 148]
	str	s0, [sp, 144]
	cmp	x8, x1
	mov	x1, x8
	beq	.L1306
	ldr	x2, [sp, 144]
	str	x2, [x1], 8
	mov	x8, x1
	str	x1, [sp, 176]
.L1307:
	sub	x1, x1, x0
	asr	x4, x1, 3
	cmp	x4, x7
	bne	.L1304
	str	xzr, [sp, 160]
	cmp	x1, 8
	bls	.L1304
	mov	w6, 0
	mov	x5, 0
	mov	x1, 1
	.p2align 3,,7
.L1311:
	lsl	x3, x5, 3
	lsl	x2, x1, 3
	ldr	s1, [x0, x3]
	ldr	s0, [x0, x2]
	fcmpe	s1, s0
	bmi	.L1357
.L1309:
	add	x1, x1, 1
	cmp	x4, x1
	bhi	.L1311
	cbnz	w6, .L1399
	b	.L1304
	.p2align 2,,3
.L1295:
	cbz	x0, .L1284
	bl	_ZdlPv
	mov	x0, x24
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 192
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L1346:
	.cfi_restore_state
	movi	v0.4s, 0
	mov	x2, 0
	b	.L1299
.L1348:
	mov	x0, 0
	mov	x1, 0
	mov	x2, 0
	b	.L1326
.L1349:
	mov	x1, 0
	b	.L1336
.L1408:
	ldp	x0, x8, [sp, 168]
	b	.L1316
	.p2align 2,,3
.L1357:
	mov	x5, x1
	mov	w6, 1
	b	.L1309
.L1306:
	add	x2, sp, 144
	add	x0, sp, 168
.LEHB86:
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE86:
	ldp	x0, x8, [sp, 168]
	ldr	x7, [sp, 152]
	mov	x1, x8
	b	.L1307
.L1407:
	adrp	x0, .LC43
	add	x0, x0, :lo12:.LC43
.LEHB87:
	bl	_ZSt20__throw_length_errorPKc
.LEHE87:
.L1355:
	ldr	x1, [sp, 168]
	mov	x19, x0
	cbz	x1, .L1345
	mov	x0, x1
.L1400:
	bl	_ZdlPv
.L1345:
	mov	x0, x19
.LEHB88:
	bl	_Unwind_Resume
.LEHE88:
.L1356:
	ldr	x1, [x24]
	mov	x19, x0
	cbz	x1, .L1323
	mov	x0, x1
	bl	_ZdlPv
.L1323:
	ldr	x0, [sp, 168]
	cbz	x0, .L1345
	bl	_ZdlPv
	b	.L1345
.L1354:
	ldr	x1, [sp, 152]
	mov	x19, x0
	cbz	x1, .L1345
	mov	x0, x1
	b	.L1400
.L1353:
	mov	x19, x0
	b	.L1323
	.cfi_endproc
.LFE10412:
	.section	.gcc_except_table
.LLSDA10412:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE10412-.LLSDACSB10412
.LLSDACSB10412:
	.uleb128 .LEHB83-.LFB10412
	.uleb128 .LEHE83-.LEHB83
	.uleb128 .L1354-.LFB10412
	.uleb128 0
	.uleb128 .LEHB84-.LFB10412
	.uleb128 .LEHE84-.LEHB84
	.uleb128 .L1355-.LFB10412
	.uleb128 0
	.uleb128 .LEHB85-.LFB10412
	.uleb128 .LEHE85-.LEHB85
	.uleb128 .L1356-.LFB10412
	.uleb128 0
	.uleb128 .LEHB86-.LFB10412
	.uleb128 .LEHE86-.LEHB86
	.uleb128 .L1353-.LFB10412
	.uleb128 0
	.uleb128 .LEHB87-.LFB10412
	.uleb128 .LEHE87-.LEHB87
	.uleb128 .L1355-.LFB10412
	.uleb128 0
	.uleb128 .LEHB88-.LFB10412
	.uleb128 .LEHE88-.LEHB88
	.uleb128 0
	.uleb128 0
.LLSDACSE10412:
	.section	.text._ZN3ann18flat_search_methodEPKfS1_mmmNS_12SearchMethodEm,"axG",@progbits,_ZN3ann18flat_search_methodEPKfS1_mmmNS_12SearchMethodEm,comdat
	.size	_ZN3ann18flat_search_methodEPKfS1_mmmNS_12SearchMethodEm, .-_ZN3ann18flat_search_methodEPKfS1_mmmNS_12SearchMethodEm
	.text
	.align	2
	.p2align 4,,11
	.global	_Z10run_methodPfS_PimmmmmN3ann12SearchMethodEm
	.type	_Z10run_methodPfS_PimmmmmN3ann12SearchMethodEm, %function
_Z10run_methodPfS_PimmmmmN3ann12SearchMethodEm:
.LFB10462:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA10462
	stp	x29, x30, [sp, -208]!
	.cfi_def_cfa_offset 208
	.cfi_offset 29, -208
	.cfi_offset 30, -200
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	stp	x6, x0, [sp, 112]
	str	x8, [sp, 136]
	str	d8, [sp, 96]
	.cfi_offset 21, -176
	.cfi_offset 22, -168
	.cfi_offset 72, -112
	cbz	x6, .L1424
	movi	v8.2s, #0
	mov	x21, x1
	stp	x23, x24, [sp, 48]
	.cfi_offset 24, -152
	.cfi_offset 23, -160
	mov	x24, 16960
	mov	x23, x7
	stp	x25, x26, [sp, 64]
	.cfi_offset 26, -136
	.cfi_offset 25, -144
	mov	x26, x2
	mov	x25, x4
	stp	x27, x28, [sp, 80]
	.cfi_offset 28, -120
	.cfi_offset 27, -128
	mov	x27, x3
	mov	x28, x5
	lsl	x0, x4, 2
	mov	x22, 0
	movk	x24, 0xf, lsl 16
	stp	x19, x20, [sp, 16]
	.cfi_offset 20, -184
	.cfi_offset 19, -192
	mov	x20, 0
	str	x0, [sp, 128]
	.p2align 3,,7
.L1419:
	mov	x1, 0
	add	x0, sp, 176
	bl	gettimeofday
	ldp	x19, x0, [sp, 176]
	mov	x3, x25
	ldr	w5, [sp, 208]
	add	x8, sp, 144
	ldr	x6, [sp, 216]
	mov	x4, x23
	mov	x2, x27
	mov	x1, x21
	madd	x19, x19, x24, x0
	ldr	x0, [sp, 120]
.LEHB89:
	bl	_ZN3ann18flat_search_methodEPKfS1_mmmNS_12SearchMethodEm
.LEHE89:
	mov	x1, 0
	add	x0, sp, 176
	bl	gettimeofday
	str	xzr, [sp, 192]
	ldp	x1, x0, [sp, 176]
	stp	xzr, xzr, [sp, 176]
	ldr	x3, [sp, 144]
	madd	x1, x1, x24, x0
	ldr	x0, [sp, 152]
	sub	x1, x1, x19
	add	x22, x22, x1
	subs	x19, x0, x3
	beq	.L1425
	mov	x0, 9223372036854775800
	cmp	x19, x0
	bhi	.L1444
	mov	x0, x19
.LEHB90:
	bl	_Znwm
.LEHE90:
	mov	x5, x0
	ldp	x3, x0, [sp, 144]
.L1413:
	add	x19, x5, x19
	stp	x5, x5, [sp, 176]
	str	x19, [sp, 192]
	cmp	x0, x3
	beq	.L1415
	sub	x0, x0, x3
	mov	x1, 0
	.p2align 3,,7
.L1416:
	ldr	x2, [x3, x1]
	str	x2, [x5, x1]
	add	x1, x1, 8
	cmp	x0, x1
	bne	.L1416
	add	x5, x5, x0
.L1415:
	mov	x4, x23
	mov	x3, x20
	mov	x2, x28
	mov	x1, x26
	add	x0, sp, 176
	str	x5, [sp, 184]
.LEHB91:
	bl	_Z11calc_recallSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EESt4lessIS1_EEPimmm
.LEHE91:
	ldr	x0, [sp, 176]
	fadd	s8, s8, s0
	cbz	x0, .L1417
	bl	_ZdlPv
.L1417:
	ldr	x0, [sp, 144]
	cbz	x0, .L1418
	bl	_ZdlPv
.L1418:
	ldr	x0, [sp, 128]
	add	x20, x20, 1
	add	x21, x21, x0
	ldr	x0, [sp, 112]
	cmp	x0, x20
	bne	.L1419
	ldp	x19, x20, [sp, 16]
	.cfi_restore 20
	.cfi_restore 19
	ldp	x23, x24, [sp, 48]
	.cfi_restore 24
	.cfi_restore 23
	ldp	x25, x26, [sp, 64]
	.cfi_restore 26
	.cfi_restore 25
	ldp	x27, x28, [sp, 80]
	.cfi_restore 28
	.cfi_restore 27
	sdiv	x22, x22, x0
.L1412:
	ldr	x0, [sp, 112]
	ucvtf	s0, x0
	ldr	x0, [sp, 136]
	fdiv	s8, s8, s0
	stp	x22, xzr, [x0, 8]
	str	xzr, [x0, 24]
	ldp	x21, x22, [sp, 32]
	str	s8, [x0]
	ldr	d8, [sp, 96]
	ldp	x29, x30, [sp], 208
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 72
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L1425:
	.cfi_def_cfa_offset 208
	.cfi_offset 19, -192
	.cfi_offset 20, -184
	.cfi_offset 21, -176
	.cfi_offset 22, -168
	.cfi_offset 23, -160
	.cfi_offset 24, -152
	.cfi_offset 25, -144
	.cfi_offset 26, -136
	.cfi_offset 27, -128
	.cfi_offset 28, -120
	.cfi_offset 29, -208
	.cfi_offset 30, -200
	.cfi_offset 72, -112
	mov	x19, 0
	mov	x5, 0
	b	.L1413
.L1424:
	.cfi_restore 19
	.cfi_restore 20
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 27
	.cfi_restore 28
	movi	v8.2s, #0
	mov	x22, 0
	b	.L1412
.L1444:
	.cfi_offset 19, -192
	.cfi_offset 20, -184
	.cfi_offset 23, -160
	.cfi_offset 24, -152
	.cfi_offset 25, -144
	.cfi_offset 26, -136
	.cfi_offset 27, -128
	.cfi_offset 28, -120
.LEHB92:
	bl	_ZSt17__throw_bad_allocv
.LEHE92:
.L1427:
	ldr	x1, [sp, 176]
	mov	x19, x0
	cbz	x1, .L1422
	mov	x0, x1
	bl	_ZdlPv
.L1422:
	ldr	x0, [sp, 144]
	cbz	x0, .L1423
	bl	_ZdlPv
.L1423:
	mov	x0, x19
.LEHB93:
	bl	_Unwind_Resume
.LEHE93:
.L1426:
	mov	x19, x0
	b	.L1422
	.cfi_endproc
.LFE10462:
	.section	.gcc_except_table
.LLSDA10462:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE10462-.LLSDACSB10462
.LLSDACSB10462:
	.uleb128 .LEHB89-.LFB10462
	.uleb128 .LEHE89-.LEHB89
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB90-.LFB10462
	.uleb128 .LEHE90-.LEHB90
	.uleb128 .L1426-.LFB10462
	.uleb128 0
	.uleb128 .LEHB91-.LFB10462
	.uleb128 .LEHE91-.LEHB91
	.uleb128 .L1427-.LFB10462
	.uleb128 0
	.uleb128 .LEHB92-.LFB10462
	.uleb128 .LEHE92-.LEHB92
	.uleb128 .L1426-.LFB10462
	.uleb128 0
	.uleb128 .LEHB93-.LFB10462
	.uleb128 .LEHE93-.LEHB93
	.uleb128 0
	.uleb128 0
.LLSDACSE10462:
	.text
	.size	_Z10run_methodPfS_PimmmmmN3ann12SearchMethodEm, .-_Z10run_methodPfS_PimmmmmN3ann12SearchMethodEm
	.section	.text._ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv,"axG",@progbits,_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	.type	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv, %function
_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv:
.LFB11874:
	.cfi_startproc
	ldp	x1, x2, [x0]
	sub	x3, x2, x1
	sub	x9, x2, #8
	cmp	x3, 8
	bgt	.L1467
	str	x9, [x0, 8]
	ret
	.p2align 2,,3
.L1467:
	sub	x4, x9, x1
	ldr	s0, [x1]
	ldr	w5, [x1, 4]
	asr	x11, x4, 3
	ldr	w10, [x2, -4]
	sub	x3, x11, #1
	str	w5, [x2, -4]
	ldr	s2, [x2, -8]
	and	x12, x11, 1
	add	x8, x3, x3, lsr 63
	str	s0, [x2, -8]
	asr	x8, x8, 1
	cmp	x4, 16
	ble	.L1447
	mov	x4, 0
	.p2align 3,,7
.L1451:
	add	x2, x4, 1
	lsl	x3, x2, 1
	lsl	x2, x2, 4
	sub	x6, x3, #1
	add	x7, x1, x2
	lsl	x5, x6, 3
	ldr	s0, [x1, x2]
	add	x2, x1, x5
	ldr	s1, [x1, x5]
	fcmpe	s0, s1
	bmi	.L1462
.L1448:
	lsl	x2, x4, 3
	ldr	w6, [x7, 4]
	add	x5, x1, x2
	mov	x4, x3
	str	s0, [x1, x2]
	str	w6, [x5, 4]
	cmp	x3, x8
	blt	.L1451
	lsl	x6, x3, 3
	cbz	x12, .L1468
.L1454:
	sub	x3, x3, #1
	asr	x4, x3, 1
	.p2align 3,,7
.L1457:
	lsl	x5, x4, 3
	sub	x2, x4, #1
	add	x8, x1, x5
	add	x7, x1, x6
	add	x2, x2, x2, lsr 63
	ldr	s0, [x1, x5]
	asr	x2, x2, 1
	fcmpe	s2, s0
	bgt	.L1463
.L1452:
	str	w10, [x7, 4]
	str	s2, [x7]
.L1470:
	str	x9, [x0, 8]
	ret
	.p2align 2,,3
.L1463:
	ldr	w3, [x8, 4]
	str	s0, [x1, x6]
	lsl	x6, x4, 3
	str	w3, [x7, 4]
	cbz	x4, .L1469
	mov	x4, x2
	b	.L1457
	.p2align 2,,3
.L1462:
	fmov	s0, s1
	mov	x7, x2
	mov	x3, x6
	b	.L1448
	.p2align 2,,3
.L1468:
	sub	x11, x11, #2
	add	x11, x11, x11, lsr 63
	cmp	x3, x11, asr 1
	beq	.L1453
	sub	x4, x3, #1
	lsl	x6, x3, 3
	asr	x4, x4, 1
	b	.L1457
	.p2align 2,,3
.L1469:
	mov	x7, x8
	str	s2, [x7]
	str	w10, [x7, 4]
	b	.L1470
	.p2align 2,,3
.L1447:
	mov	x7, x1
	cbnz	x12, .L1452
	cmp	x3, 2
	bhi	.L1452
	mov	x3, 0
	.p2align 3,,7
.L1453:
	lsl	x3, x3, 1
	add	x3, x3, 1
	lsl	x6, x3, 3
	add	x2, x1, x6
	ldr	s0, [x1, x6]
	ldr	w2, [x2, 4]
	str	w2, [x7, 4]
	str	s0, [x7]
	b	.L1454
	.cfi_endproc
.LFE11874:
	.size	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv, .-_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE22getConnectionsWithLockEji,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE22getConnectionsWithLockEji,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib15HierarchicalNSWIfE22getConnectionsWithLockEji
	.type	_ZN7hnswlib15HierarchicalNSWIfE22getConnectionsWithLockEji, %function
_ZN7hnswlib15HierarchicalNSWIfE22getConnectionsWithLockEji:
.LFB11893:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA11893
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	mov	w3, 48
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -48
	.cfi_offset 22, -40
	mov	x21, x0
	ldr	x0, [x0, 192]
	stp	x19, x20, [sp, 16]
	.cfi_offset 20, -56
	.cfi_offset 19, -64
	strb	wzr, [sp, 72]
	umaddl	x0, w1, w3, x0
	str	x0, [sp, 64]
	cbz	x0, .L1496
	uxtw	x22, w1
	adrp	x1, .LC36
	mov	x20, x8
	mov	w19, w2
	ldr	x1, [x1, #:lo12:.LC36]
	cbz	x1, .L1473
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L1497
.L1473:
	mov	w0, 1
	strb	w0, [sp, 72]
	cbz	w19, .L1498
	ldr	x0, [x21, 264]
	sub	w19, w19, #1
	ldr	x1, [x21, 32]
	sxtw	x19, w19
	ldr	x0, [x0, x22, lsl 3]
	madd	x19, x19, x1, x0
	ldrh	w21, [x19]
	stp	xzr, xzr, [x20]
	str	xzr, [x20, 16]
	cbz	w21, .L1476
.L1500:
	ubfiz	x21, x21, 2, 16
	stp	x23, x24, [sp, 48]
	.cfi_offset 24, -24
	.cfi_offset 23, -32
	mov	x0, x21
.LEHB94:
	bl	_Znwm
.LEHE94:
	add	x23, x0, x21
	str	x0, [x20]
	str	x23, [x20, 16]
	mov	x2, x21
	mov	x22, x0
	mov	w1, 0
	bl	memset
	ldrb	w24, [sp, 72]
	str	x23, [x20, 8]
	mov	x0, x22
	mov	x2, x21
	add	x1, x19, 4
	bl	memcpy
	cbnz	w24, .L1499
	mov	x0, x20
	ldp	x19, x20, [sp, 16]
	.cfi_restore 20
	.cfi_restore 19
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	.cfi_restore 24
	.cfi_restore 23
	ldp	x29, x30, [sp], 80
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 22
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L1498:
	.cfi_def_cfa_offset 80
	.cfi_offset 19, -64
	.cfi_offset 20, -56
	.cfi_offset 21, -48
	.cfi_offset 22, -40
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	ldr	x1, [x21, 24]
	ldr	x0, [x21, 240]
	ldr	x19, [x21, 256]
	madd	x22, x22, x1, x0
	add	x19, x19, x22
	ldrh	w21, [x19]
	stp	xzr, xzr, [x20]
	str	xzr, [x20, 16]
	cbnz	w21, .L1500
.L1476:
	stp	xzr, xzr, [x20]
	str	xzr, [x20, 16]
.L1480:
	add	x0, sp, 64
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
	mov	x0, x20
	ldp	x19, x20, [sp, 16]
	.cfi_remember_state
	.cfi_restore 20
	.cfi_restore 19
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 80
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 22
	.cfi_def_cfa_offset 0
	ret
.L1496:
	.cfi_restore_state
	mov	w0, 1
	stp	x23, x24, [sp, 48]
	.cfi_remember_state
	.cfi_offset 24, -24
	.cfi_offset 23, -32
.LEHB95:
	bl	_ZSt20__throw_system_errori
.L1497:
	.cfi_restore_state
	stp	x23, x24, [sp, 48]
	.cfi_offset 24, -24
	.cfi_offset 23, -32
	bl	_ZSt20__throw_system_errori
.LEHE95:
.L1499:
	ldp	x23, x24, [sp, 48]
	.cfi_remember_state
	.cfi_restore 24
	.cfi_restore 23
	b	.L1480
.L1481:
	.cfi_restore_state
	ldrb	w1, [sp, 72]
	mov	x19, x0
	cbz	w1, .L1479
	add	x0, sp, 64
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
.L1479:
	mov	x0, x19
.LEHB96:
	bl	_Unwind_Resume
.LEHE96:
	.cfi_endproc
.LFE11893:
	.section	.gcc_except_table
.LLSDA11893:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE11893-.LLSDACSB11893
.LLSDACSB11893:
	.uleb128 .LEHB94-.LFB11893
	.uleb128 .LEHE94-.LEHB94
	.uleb128 .L1481-.LFB11893
	.uleb128 0
	.uleb128 .LEHB95-.LFB11893
	.uleb128 .LEHE95-.LEHB95
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB96-.LFB11893
	.uleb128 .LEHE96-.LEHB96
	.uleb128 0
	.uleb128 0
.LLSDACSE11893:
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE22getConnectionsWithLockEji,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE22getConnectionsWithLockEji,comdat
	.size	_ZN7hnswlib15HierarchicalNSWIfE22getConnectionsWithLockEji, .-_ZN7hnswlib15HierarchicalNSWIfE22getConnectionsWithLockEji
	.section	.text._ZNSt5dequeIPN7hnswlib11VisitedListESaIS2_EE17_M_reallocate_mapEmb,"axG",@progbits,_ZNSt5dequeIPN7hnswlib11VisitedListESaIS2_EE17_M_reallocate_mapEmb,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt5dequeIPN7hnswlib11VisitedListESaIS2_EE17_M_reallocate_mapEmb
	.type	_ZNSt5dequeIPN7hnswlib11VisitedListESaIS2_EE17_M_reallocate_mapEmb, %function
_ZNSt5dequeIPN7hnswlib11VisitedListESaIS2_EE17_M_reallocate_mapEmb:
.LFB11989:
	.cfi_startproc
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -32
	.cfi_offset 22, -24
	mov	x21, x1
	ldr	x1, [x0, 40]
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -48
	.cfi_offset 20, -40
	mov	x20, x0
	ldr	x3, [x0, 72]
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -16
	.cfi_offset 24, -8
	and	w24, w2, 255
	sub	x22, x3, x1
	ldr	x0, [x0, 8]
	asr	x19, x22, 3
	add	x19, x19, 1
	add	x19, x19, x21
	cmp	x0, x19, lsl 1
	bls	.L1502
	sub	x0, x0, x19
	cmp	w24, 0
	ldr	x19, [x20]
	lsr	x0, x0, 1
	add	x3, x3, 8
	lsl	x0, x0, 3
	sub	x2, x3, x1
	add	x21, x0, x21, lsl 3
	csel	x0, x21, x0, ne
	add	x19, x19, x0
	cmp	x1, x19
	bls	.L1504
	cmp	x1, x3
	beq	.L1505
	mov	x0, x19
	bl	memmove
	b	.L1505
	.p2align 2,,3
.L1502:
	cmp	x0, x21
	add	x23, x0, 2
	csel	x0, x0, x21, cs
	mov	x1, 1152921504606846975
	add	x23, x23, x0
	cmp	x23, x1
	bhi	.L1514
	sub	x19, x23, x19
	lsl	x0, x23, 3
	bl	_Znwm
	lsr	x19, x19, 1
	cmp	w24, 0
	ldr	x3, [x20, 72]
	lsl	x19, x19, 3
	ldr	x1, [x20, 40]
	add	x21, x19, x21, lsl 3
	csel	x19, x21, x19, ne
	add	x3, x3, 8
	mov	x24, x0
	add	x19, x0, x19
	cmp	x1, x3
	beq	.L1508
	sub	x2, x3, x1
	mov	x0, x19
	bl	memmove
.L1508:
	ldr	x0, [x20]
	bl	_ZdlPv
	stp	x24, x23, [x20]
.L1505:
	add	x2, x19, x22
	ldr	x0, [x19]
	ldp	x23, x24, [sp, 48]
	str	x0, [x20, 24]
	add	x0, x0, 512
	str	x0, [x20, 32]
	str	x19, [x20, 40]
	ldr	x0, [x19, x22]
	ldp	x21, x22, [sp, 32]
	str	x0, [x20, 56]
	add	x0, x0, 512
	str	x0, [x20, 64]
	str	x2, [x20, 72]
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 64
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L1504:
	.cfi_restore_state
	cmp	x1, x3
	beq	.L1505
	add	x0, x22, 8
	sub	x0, x0, x2
	add	x0, x19, x0
	bl	memmove
	b	.L1505
.L1514:
	bl	_ZSt17__throw_bad_allocv
	.cfi_endproc
.LFE11989:
	.size	_ZNSt5dequeIPN7hnswlib11VisitedListESaIS2_EE17_M_reallocate_mapEmb, .-_ZNSt5dequeIPN7hnswlib11VisitedListESaIS2_EE17_M_reallocate_mapEmb
	.section	.text._ZNSt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EE11_M_gen_randEv,"axG",@progbits,_ZNSt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EE11_M_gen_randEv,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EE11_M_gen_randEv
	.type	_ZNSt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EE11_M_gen_randEv, %function
_ZNSt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EE11_M_gen_randEv:
.LFB12050:
	.cfi_startproc
	mov	x7, 45279
	mov	x1, x0
	add	x6, x0, 1816
	mov	x3, x0
	movk	x7, 0x9908, lsl 16
	.p2align 3,,7
.L1517:
	ldp	x4, x5, [x3]
	ldr	x2, [x3, 3176]
	bfi	x4, x5, 0, 31
	eor	x2, x2, x4, lsr 1
	tst	x4, 1
	eor	x4, x2, x7
	csel	x2, x4, x2, ne
	str	x2, [x3], 8
	cmp	x6, x3
	bne	.L1517
	mov	x5, 45279
	add	x6, x0, 3168
	movk	x5, 0x9908, lsl 16
	.p2align 3,,7
.L1519:
	ldr	x3, [x1, 1816]
	add	x1, x1, 8
	ldr	x4, [x1, 1816]
	ldr	x2, [x1, -8]
	bfi	x3, x4, 0, 31
	eor	x2, x2, x3, lsr 1
	tst	x3, 1
	eor	x3, x2, x5
	csel	x2, x3, x2, ne
	str	x2, [x1, 1808]
	cmp	x6, x1
	bne	.L1519
	ldr	x4, [x0]
	mov	x3, 45279
	ldr	x2, [x0, 4984]
	movk	x3, 0x9908, lsl 16
	ldr	x1, [x0, 3168]
	str	xzr, [x0, 4992]
	bfi	x2, x4, 0, 31
	eor	x1, x1, x2, lsr 1
	tst	x2, 1
	eor	x2, x1, x3
	csel	x1, x2, x1, ne
	str	x1, [x0, 4984]
	ret
	.cfi_endproc
.LFE12050:
	.size	_ZNSt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EE11_M_gen_randEv, .-_ZNSt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EE11_M_gen_randEv
	.section	.text._ZNSt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEclEv,"axG",@progbits,_ZNSt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEclEv,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEclEv
	.type	_ZNSt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEclEv, %function
_ZNSt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEclEv:
.LFB11721:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	ldr	x2, [x0, 4992]
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	mov	x19, x0
	cmp	x2, 623
	bhi	.L1532
.L1530:
	ldr	x3, [x19, x2, lsl 3]
	add	x2, x2, 1
	str	x2, [x19, 4992]
	mov	x1, 22144
	movk	x1, 0x9d2c, lsl 16
	mov	x0, 4022730752
	ubfx	x2, x3, 11, 32
	eor	x2, x2, x3
	ldr	x19, [sp, 16]
	and	x1, x1, x2, lsl 7
	eor	x1, x1, x2
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	and	x0, x0, x1, lsl 15
	eor	x0, x0, x1
	eor	x0, x0, x0, lsr 18
	ret
	.p2align 2,,3
.L1532:
	.cfi_restore_state
	bl	_ZNSt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EE11_M_gen_randEv
	ldr	x2, [x19, 4992]
	b	.L1530
	.cfi_endproc
.LFE11721:
	.size	_ZNSt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEclEv, .-_ZNSt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEclEv
	.section	.text._ZNSt24uniform_int_distributionImEclISt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEEEmRT_RKNS0_10param_typeE.isra.0,"axG",@progbits,_ZSt7shuffleIN9__gnu_cxx17__normal_iteratorIPmSt6vectorImSaImEEEERSt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEEvT_SA_OT0_,comdat
	.align	2
	.p2align 4,,11
	.type	_ZNSt24uniform_int_distributionImEclISt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEEEmRT_RKNS0_10param_typeE.isra.0, %function
_ZNSt24uniform_int_distributionImEclISt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEEEmRT_RKNS0_10param_typeE.isra.0:
.LFB13059:
	.cfi_startproc
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -64
	.cfi_offset 20, -56
	mov	x20, x1
	mov	x1, 4294967294
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -48
	.cfi_offset 22, -40
	mov	x21, x0
	ldp	x2, x22, [x20]
	sub	x22, x22, x2
	cmp	x22, x1
	bhi	.L1534
	add	x22, x22, 1
	mov	x19, 4294967295
	stp	x23, x24, [sp, 48]
	.cfi_offset 24, -24
	.cfi_offset 23, -32
	mov	x24, 22144
	movk	x24, 0x9d2c, lsl 16
	udiv	x19, x19, x22
	mov	x23, 4022730752
	ldr	x0, [x0, 4992]
	mul	x22, x22, x19
	b	.L1536
	.p2align 2,,3
.L1535:
	ldr	x2, [x21, x1, lsl 3]
	add	x0, x1, 1
	str	x0, [x21, 4992]
	ubfx	x1, x2, 11, 32
	eor	x2, x2, x1
	and	x1, x24, x2, lsl 7
	eor	x2, x2, x1
	and	x1, x23, x2, lsl 15
	eor	x2, x2, x1
	eor	x2, x2, x2, lsr 18
	cmp	x22, x2
	bhi	.L1545
.L1536:
	mov	x1, x0
	cmp	x0, 623
	bls	.L1535
	mov	x0, x21
	bl	_ZNSt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EE11_M_gen_randEv
	ldr	x1, [x21, 4992]
	b	.L1535
	.p2align 2,,3
.L1534:
	.cfi_restore 23
	.cfi_restore 24
	mov	x1, 4294967295
	cmp	x22, x1
	beq	.L1538
	stp	x23, x24, [sp, 48]
	.cfi_offset 24, -24
	.cfi_offset 23, -32
	lsr	x23, x22, 32
.L1541:
	add	x1, sp, 64
	mov	x0, x21
	stp	xzr, x23, [sp, 64]
	bl	_ZNSt24uniform_int_distributionImEclISt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEEEmRT_RKNS0_10param_typeE.isra.0
	mov	x19, x0
	mov	x0, x21
	bl	_ZNSt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEclEv
	lsl	x2, x19, 32
	adds	x2, x2, x0
	ccmp	x22, x2, 0, cc
	bcc	.L1541
	ldr	x0, [x20]
	ldp	x19, x20, [sp, 16]
	add	x0, x2, x0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	.cfi_remember_state
	.cfi_restore 24
	.cfi_restore 23
	ldp	x29, x30, [sp], 80
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L1545:
	.cfi_restore_state
	udiv	x2, x2, x19
	ldr	x0, [x20]
	ldp	x19, x20, [sp, 16]
	add	x0, x2, x0
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	.cfi_restore 24
	.cfi_restore 23
	ldp	x29, x30, [sp], 80
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L1538:
	.cfi_def_cfa_offset 80
	.cfi_offset 19, -64
	.cfi_offset 20, -56
	.cfi_offset 21, -48
	.cfi_offset 22, -40
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	bl	_ZNSt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEclEv
	mov	x2, x0
	ldr	x0, [x20]
	ldp	x19, x20, [sp, 16]
	add	x0, x2, x0
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 80
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.cfi_endproc
.LFE13059:
	.size	_ZNSt24uniform_int_distributionImEclISt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEEEmRT_RKNS0_10param_typeE.isra.0, .-_ZNSt24uniform_int_distributionImEclISt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEEEmRT_RKNS0_10param_typeE.isra.0
	.section	.text._ZSt7shuffleIN9__gnu_cxx17__normal_iteratorIPmSt6vectorImSaImEEEERSt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEEvT_SA_OT0_,"axG",@progbits,_ZSt7shuffleIN9__gnu_cxx17__normal_iteratorIPmSt6vectorImSaImEEEERSt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEEvT_SA_OT0_,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZSt7shuffleIN9__gnu_cxx17__normal_iteratorIPmSt6vectorImSaImEEEERSt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEEvT_SA_OT0_
	.type	_ZSt7shuffleIN9__gnu_cxx17__normal_iteratorIPmSt6vectorImSaImEEEERSt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEEvT_SA_OT0_, %function
_ZSt7shuffleIN9__gnu_cxx17__normal_iteratorIPmSt6vectorImSaImEEEERSt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEEvT_SA_OT0_:
.LFB10917:
	.cfi_startproc
	cmp	x1, x0
	beq	.L1555
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -64
	.cfi_offset 20, -56
	mov	x20, x0
	sub	x0, x1, x0
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -48
	.cfi_offset 22, -40
	mov	x21, x1
	asr	x0, x0, 3
	mov	x1, 4294967295
	mov	x22, x2
	add	x19, x20, 8
	udiv	x1, x1, x0
	cmp	x1, x0
	bcs	.L1559
	cmp	x21, x19
	beq	.L1546
	stp	x23, x24, [sp, 48]
	.cfi_offset 24, -24
	.cfi_offset 23, -32
	add	x23, sp, 64
	.p2align 3,,7
.L1551:
	sub	x2, x19, x20
	mov	x1, x23
	mov	x0, x22
	asr	x2, x2, 3
	stp	xzr, x2, [sp, 64]
	bl	_ZNSt24uniform_int_distributionImEclISt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEEEmRT_RKNS0_10param_typeE.isra.0
	ldr	x2, [x20, x0, lsl 3]
	ldr	x1, [x19]
	str	x2, [x19], 8
	str	x1, [x20, x0, lsl 3]
	cmp	x21, x19
	bne	.L1551
	ldp	x23, x24, [sp, 48]
	.cfi_restore 24
	.cfi_restore 23
.L1546:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 80
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L1559:
	.cfi_restore_state
	tbz	x0, 0, .L1560
.L1549:
	cmp	x21, x19
	beq	.L1546
	stp	x23, x24, [sp, 48]
	.cfi_offset 24, -24
	.cfi_offset 23, -32
	add	x23, sp, 64
	.p2align 3,,7
.L1550:
	sub	x3, x19, x20
	mov	x1, x23
	mov	x0, x22
	asr	x3, x3, 3
	add	x19, x19, 16
	add	x24, x3, 2
	madd	x3, x3, x24, x24
	sub	x3, x3, #1
	stp	xzr, x3, [sp, 64]
	bl	_ZNSt24uniform_int_distributionImEclISt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEEEmRT_RKNS0_10param_typeE.isra.0
	udiv	x1, x0, x24
	ldr	x2, [x19, -16]
	msub	x24, x1, x24, x0
	ldr	x0, [x20, x1, lsl 3]
	str	x0, [x19, -16]
	str	x2, [x20, x1, lsl 3]
	ldr	x1, [x20, x24, lsl 3]
	ldr	x0, [x19, -8]
	str	x1, [x19, -8]
	str	x0, [x20, x24, lsl 3]
	cmp	x21, x19
	bne	.L1550
	ldp	x23, x24, [sp, 48]
	.cfi_restore 24
	.cfi_restore 23
	b	.L1546
	.p2align 2,,3
.L1560:
	mov	x2, 1
	add	x1, sp, 64
	mov	x0, x22
	stp	xzr, x2, [sp, 64]
	bl	_ZNSt24uniform_int_distributionImEclISt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEEEmRT_RKNS0_10param_typeE.isra.0
	ldr	x2, [x20, x0, lsl 3]
	add	x19, x20, 16
	ldr	x1, [x20, 8]
	str	x2, [x20, 8]
	str	x1, [x20, x0, lsl 3]
	b	.L1549
	.p2align 2,,3
.L1555:
	.cfi_def_cfa_offset 0
	.cfi_restore 19
	.cfi_restore 20
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 29
	.cfi_restore 30
	ret
	.cfi_endproc
.LFE10917:
	.size	_ZSt7shuffleIN9__gnu_cxx17__normal_iteratorIPmSt6vectorImSaImEEEERSt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEEvT_SA_OT0_, .-_ZSt7shuffleIN9__gnu_cxx17__normal_iteratorIPmSt6vectorImSaImEEEERSt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEEvT_SA_OT0_
	.section	.text._ZN3ann14build_pq_indexEPKfmmiiiiRNS_7PQIndexE,"axG",@progbits,_ZN3ann14build_pq_indexEPKfmmiiiiRNS_7PQIndexE,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN3ann14build_pq_indexEPKfmmiiiiRNS_7PQIndexE
	.type	_ZN3ann14build_pq_indexEPKfmmiiiiRNS_7PQIndexE, %function
_ZN3ann14build_pq_indexEPKfmmiiiiRNS_7PQIndexE:
.LFB10431:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA10431
	mov	x12, 5248
	sub	sp, sp, x12
	.cfi_def_cfa_offset 5248
	stp	x29, x30, [sp]
	.cfi_offset 29, -5248
	.cfi_offset 30, -5240
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -5216
	.cfi_offset 22, -5208
	sxtw	x21, w3
	mov	x22, x7
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -5200
	.cfi_offset 24, -5192
	mov	x23, x2
	sxtw	x2, w5
	stp	x19, x20, [sp, 16]
	cmp	x2, x1
	.cfi_offset 19, -5232
	.cfi_offset 20, -5224
	mov	w19, w4
	udiv	x20, x23, x21
	smull	x4, w3, w4
	csel	x2, x2, x1, ls
	mov	w5, w3
	stp	w3, w6, [sp, 144]
	mov	x3, x1
	str	x1, [sp, 200]
	sxtw	x1, w20
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -5184
	.cfi_offset 26, -5176
	mov	x26, x0
	str	x3, [x7]
	add	x3, x7, 40
	mul	x1, x4, x1
	str	x23, [x7, 8]
	str	w5, [x7, 16]
	mov	x0, x3
	stp	w19, w20, [x7, 20]
	msub	x20, x20, x21, x23
	stp	w2, w6, [x7, 28]
	add	x2, sp, 248
	str	x21, [sp, 160]
	str	x3, [sp, 176]
	str	wzr, [sp, 248]
.LEHB97:
	bl	_ZNSt6vectorIfSaIfEE14_M_fill_assignEmRKf
	ldr	x1, [sp, 200]
	sxtw	x3, w19
	str	x3, [sp, 112]
	sbfiz	x3, x19, 2, 32
	add	x0, x22, 64
	add	x2, sp, 248
	mul	x1, x21, x1
	str	x3, [sp, 136]
	strb	wzr, [sp, 248]
	bl	_ZNSt6vectorIhSaIhEE14_M_fill_assignEmRKh
	cbnz	x20, .L1561
	sub	w0, w19, #1
	str	w0, [sp, 152]
	cmp	w0, 255
	bls	.L1660
.L1561:
	mov	x12, 5248
	ldp	x29, x30, [sp]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	add	sp, sp, x12
	.cfi_remember_state
	.cfi_restore 29
	.cfi_restore 30
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
.L1660:
	.cfi_restore_state
	ldrsw	x24, [x22, 28]
	mov	x0, 1152921504606846975
	cmp	x24, x0
	bhi	.L1661
	cbz	x24, .L1616
	lsl	x20, x24, 3
	mov	x0, x20
	bl	_Znwm
.LEHE97:
	mov	x2, x20
	mov	x21, x0
	mov	w1, 0
	bl	memset
	ldr	x2, [sp, 200]
	add	x1, x21, x20
	mov	x0, x21
	sub	x4, x24, #1
	sub	x2, x2, #1
	mov	x3, 0
	b	.L1568
.L1662:
	udiv	x5, x3, x4
	add	x3, x3, x2
	str	x5, [x0], 8
	cmp	x1, x0
	beq	.L1566
.L1568:
	cmp	x24, 1
	bne	.L1662
	str	xzr, [x0]
.L1566:
	mov	x5, 35173
	mov	x4, 12345
	add	x2, sp, 256
	mov	x0, x4
	mov	x3, 1
	movk	x5, 0x6c07, lsl 16
	str	x4, [sp, 248]
	b	.L1570
	.p2align 2,,3
.L1663:
	add	x2, x2, 8
.L1570:
	eor	x0, x0, x0, lsr 30
	madd	w0, w0, w5, w3
	add	x3, x3, 1
	str	x0, [x2]
	cmp	x3, 624
	bne	.L1663
	add	x2, sp, 248
	mov	x0, x21
	str	x3, [sp, 5240]
	bl	_ZSt7shuffleIN9__gnu_cxx17__normal_iteratorIPmSt6vectorImSaImEEEERSt23mersenne_twister_engineImLm32ELm624ELm397ELm31ELm2567483615ELm11ELm4294967295ELm7ELm2636928640ELm15ELm4022730752ELm18ELm1812433253EEEvT_SA_OT0_
	cbz	x24, .L1617
	lsl	x20, x24, 2
	mov	x0, x20
.LEHB98:
	bl	_Znwm
.LEHE98:
	stp	x27, x28, [sp, 80]
	.cfi_remember_state
	.cfi_offset 28, -5160
	.cfi_offset 27, -5168
	mov	x25, x0
	cbz	x20, .L1571
	mov	x2, x20
	mov	w1, 0
	bl	memset
	b	.L1571
.L1617:
	.cfi_restore_state
	mov	x25, 0
	stp	x27, x28, [sp, 80]
	.cfi_offset 28, -5160
	.cfi_offset 27, -5168
.L1571:
	ldr	w27, [x22, 24]
	mov	x0, 2305843009213693951
	smull	x27, w19, w27
	cmp	x27, x0
	bhi	.L1664
	cbz	x27, .L1618
	lsl	x27, x27, 2
	mov	x0, x27
.LEHB99:
	bl	_Znwm
.LEHE99:
	add	x3, x0, x27
	mov	x2, x27
	mov	x20, x0
	mov	w1, 0
	str	x3, [sp, 120]
	bl	memset
.L1573:
	ldr	x1, [sp, 112]
	mov	x0, 2305843009213693951
	cmp	x1, x0
	bhi	.L1665
	ldr	x0, [sp, 112]
	cbz	x0, .L1575
	ldr	x27, [sp, 136]
	mov	x0, x27
.LEHB100:
	bl	_Znwm
.LEHE100:
	add	x1, x0, x27
	str	x1, [sp, 128]
	mov	x28, x0
	mov	x2, x27
	cmp	x1, x0
	beq	.L1576
	mov	w1, 0
	bl	memset
.L1576:
	ldr	w0, [sp, 144]
	cmp	w0, 0
	ble	.L1666
	stp	d8, d9, [sp, 96]
	.cfi_offset 73, -5144
	.cfi_offset 72, -5152
.L1614:
	ldr	w0, [sp, 152]
	mov	x27, x25
	mov	x6, x22
	mov	x25, x23
	mov	x22, x20
	mov	x23, x21
	mov	w20, w19
	mov	x7, 0
	fmov	s9, 1.0e+0
	str	x0, [sp, 168]
	mov	w0, 2139095039
	fmov	s8, w0
.L1583:
	ldrsw	x0, [x6, 24]
	mov	x3, 0
	ldr	x1, [sp, 176]
	mov	x19, 0
	ldr	x2, [sp, 136]
	mul	x21, x0, x7
	ldr	x1, [x1]
	str	x22, [sp, 152]
	mov	x22, x7
	str	x28, [sp, 184]
	mov	x28, x27
	mov	x27, x24
	madd	x21, x21, x2, x1
	mov	x24, x6
	str	w20, [sp, 192]
	mov	x20, x3
	b	.L1580
.L1667:
	ldrsw	x0, [x24, 24]
	add	x19, x19, 1
.L1580:
	ldr	x1, [sp, 112]
	lsl	x2, x0, 2
	udiv	x3, x20, x1
	mul	x1, x0, x22
	madd	x0, x2, x19, x21
	add	x20, x20, x27
	ldr	x4, [x23, x3, lsl 3]
	madd	x1, x25, x4, x1
	add	x1, x26, x1, lsl 2
	bl	memcpy
	ldr	x0, [sp, 168]
	cmp	x0, x19
	bne	.L1667
	mov	x7, x22
	mov	x6, x24
	ldr	x0, [sp, 120]
	mov	x24, x27
	ldr	x22, [sp, 152]
	mov	x27, x28
	ldr	x28, [sp, 184]
	sub	x0, x0, x22
	str	x0, [sp, 184]
	mov	w19, 0
	ldr	w0, [sp, 148]
	ldr	w20, [sp, 192]
	cmp	w0, 0
	ble	.L1603
	str	x7, [sp, 152]
.L1581:
	ldr	x0, [sp, 120]
	cmp	x22, x0
	beq	.L1587
	ldr	x2, [sp, 184]
	mov	x0, x22
	mov	w1, 0
	str	x6, [sp, 192]
	bl	memset
	ldr	x6, [sp, 192]
.L1587:
	ldr	x0, [sp, 128]
	cmp	x0, x28
	beq	.L1585
	ldr	x0, [sp, 128]
	mov	w1, 0
	str	x6, [sp, 192]
	sub	x2, x0, x28
	mov	x0, x28
	bl	memset
	ldr	x6, [sp, 192]
.L1585:
	cbz	x24, .L1596
	ldr	w1, [x6, 24]
	mov	x9, 0
	ldr	x0, [sp, 152]
	sxtw	x10, w1
	lsl	x7, x10, 2
	mul	x10, x10, x0
	.p2align 3,,7
.L1597:
	ldr	x3, [x23, x9, lsl 3]
	fmov	s3, s8
	mov	x2, x21
	mov	w4, 0
	mov	w5, 0
	madd	x3, x25, x3, x10
	add	x3, x26, x3, lsl 2
	.p2align 3,,7
.L1594:
	movi	v1.2s, #0
	cmp	w1, 0
	ble	.L1590
	mov	x0, 0
	.p2align 3,,7
.L1591:
	ldr	s0, [x3, x0, lsl 2]
	ldr	s2, [x2, x0, lsl 2]
	add	x0, x0, 1
	fsub	s0, s0, s2
	fmadd	s1, s0, s0, s1
	cmp	w1, w0
	bgt	.L1591
.L1590:
	fcmpe	s3, s1
	bgt	.L1625
.L1592:
	add	w4, w4, 1
	add	x2, x2, x7
	cmp	w20, w4
	bgt	.L1594
	sxtw	x4, w5
	str	w5, [x27, x9, lsl 2]
	mov	x0, 0
	ldr	w5, [x28, x4, lsl 2]
	madd	x2, x4, x7, x22
	add	w5, w5, 1
	str	w5, [x28, x4, lsl 2]
	cmp	w1, 0
	ble	.L1598
	.p2align 3,,7
.L1595:
	ldr	s0, [x2, x0, lsl 2]
	ldr	s1, [x3, x0, lsl 2]
	fadd	s0, s0, s1
	str	s0, [x2, x0, lsl 2]
	add	x0, x0, 1
	cmp	w1, w0
	bgt	.L1595
.L1598:
	add	x9, x9, 1
	cmp	x24, x9
	bne	.L1597
.L1596:
	mov	x2, 0
	b	.L1589
.L1601:
	add	x2, x2, 1
	cmp	w20, w2
	ble	.L1668
.L1589:
	ldr	w0, [x28, x2, lsl 2]
	cbz	w0, .L1601
	ldr	w3, [x6, 24]
	scvtf	s1, w0
	sxtw	x1, w3
	fdiv	s1, s9, s1
	mul	x0, x1, x2
	cmp	w3, 0
	ble	.L1601
	add	x1, x1, x0
	lsl	x0, x0, 2
	lsl	x1, x1, 2
	.p2align 3,,7
.L1602:
	ldr	s0, [x22, x0]
	fmul	s0, s0, s1
	str	s0, [x21, x0]
	add	x0, x0, 4
	cmp	x1, x0
	bne	.L1602
	add	x2, x2, 1
	cmp	w20, w2
	bgt	.L1589
.L1668:
	ldr	w0, [sp, 148]
	add	w19, w19, 1
	cmp	w0, w19
	bne	.L1581
	ldr	x7, [sp, 152]
.L1603:
	add	x7, x7, 1
	ldr	x0, [sp, 160]
	cmp	x0, x7
	bne	.L1583
	add	x4, sp, 200
	stp	x26, x4, [sp, 208]
	ldr	w4, [sp, 144]
	mov	w19, w20
	mov	x21, x23
	add	x1, sp, 208
	mov	x23, x25
	adrp	x0, _ZN3ann14build_pq_indexEPKfmmiiiiRNS_7PQIndexE._omp_fn.0
	mov	w3, 0
	add	x0, x0, :lo12:_ZN3ann14build_pq_indexEPKfmmiiiiRNS_7PQIndexE._omp_fn.0
	mov	w2, 0
	stp	x23, x6, [sp, 224]
	mov	x25, x27
	mov	x20, x22
	str	w4, [sp, 240]
	str	w19, [sp, 244]
	bl	GOMP_parallel
	ldp	d8, d9, [sp, 96]
	.cfi_restore 73
	.cfi_restore 72
	cbz	x28, .L1578
.L1577:
	mov	x0, x28
	bl	_ZdlPv
.L1578:
	cbz	x20, .L1604
	mov	x0, x20
	bl	_ZdlPv
.L1604:
	cbz	x25, .L1605
	mov	x0, x25
	bl	_ZdlPv
.L1605:
	cbz	x21, .L1658
	mov	x0, x21
	bl	_ZdlPv
	mov	x12, 5248
	ldp	x29, x30, [sp]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	.cfi_restore 28
	.cfi_restore 27
	add	sp, sp, x12
	.cfi_restore 29
	.cfi_restore 30
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L1625:
	.cfi_def_cfa_offset 5248
	.cfi_offset 19, -5232
	.cfi_offset 20, -5224
	.cfi_offset 21, -5216
	.cfi_offset 22, -5208
	.cfi_offset 23, -5200
	.cfi_offset 24, -5192
	.cfi_offset 25, -5184
	.cfi_offset 26, -5176
	.cfi_offset 27, -5168
	.cfi_offset 28, -5160
	.cfi_offset 29, -5248
	.cfi_offset 30, -5240
	.cfi_offset 72, -5152
	.cfi_offset 73, -5144
	fmov	s3, s1
	mov	w5, w4
	b	.L1592
.L1575:
	.cfi_restore 72
	.cfi_restore 73
	ldr	w0, [sp, 144]
	cmp	w0, 0
	ble	.L1615
	mov	x28, 0
	stp	d8, d9, [sp, 96]
	.cfi_offset 73, -5144
	.cfi_offset 72, -5152
	str	xzr, [sp, 128]
	b	.L1614
.L1616:
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 72
	.cfi_restore 73
	mov	x21, 0
	mov	x1, 0
	b	.L1566
.L1618:
	.cfi_offset 27, -5168
	.cfi_offset 28, -5160
	mov	x20, 0
	str	xzr, [sp, 120]
	b	.L1573
.L1658:
	mov	x12, 5248
	ldp	x29, x30, [sp]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	.cfi_restore 28
	.cfi_restore 27
	add	sp, sp, x12
	.cfi_restore 29
	.cfi_restore 30
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
.L1661:
	.cfi_def_cfa_offset 5248
	.cfi_offset 19, -5232
	.cfi_offset 20, -5224
	.cfi_offset 21, -5216
	.cfi_offset 22, -5208
	.cfi_offset 23, -5200
	.cfi_offset 24, -5192
	.cfi_offset 25, -5184
	.cfi_offset 26, -5176
	.cfi_offset 29, -5248
	.cfi_offset 30, -5240
	adrp	x0, .LC37
	add	x0, x0, :lo12:.LC37
	stp	x27, x28, [sp, 80]
	.cfi_offset 28, -5160
	.cfi_offset 27, -5168
	stp	d8, d9, [sp, 96]
	.cfi_offset 73, -5144
	.cfi_offset 72, -5152
.LEHB101:
	bl	_ZSt20__throw_length_errorPKc
.LEHE101:
	.p2align 2,,3
.L1615:
	.cfi_restore 72
	.cfi_restore 73
	add	x4, sp, 200
	stp	x26, x4, [sp, 208]
	ldr	w4, [sp, 144]
	add	x1, sp, 208
	adrp	x0, _ZN3ann14build_pq_indexEPKfmmiiiiRNS_7PQIndexE._omp_fn.0
	mov	w3, 0
	add	x0, x0, :lo12:_ZN3ann14build_pq_indexEPKfmmiiiiRNS_7PQIndexE._omp_fn.0
	mov	w2, 0
	stp	x23, x22, [sp, 224]
	str	w4, [sp, 240]
	str	w19, [sp, 244]
	bl	GOMP_parallel
	b	.L1578
.L1666:
	add	x4, sp, 200
	stp	x26, x4, [sp, 208]
	ldr	w4, [sp, 144]
	add	x1, sp, 208
	adrp	x0, _ZN3ann14build_pq_indexEPKfmmiiiiRNS_7PQIndexE._omp_fn.0
	mov	w3, 0
	add	x0, x0, :lo12:_ZN3ann14build_pq_indexEPKfmmiiiiRNS_7PQIndexE._omp_fn.0
	mov	w2, 0
	stp	x23, x22, [sp, 224]
	str	w4, [sp, 240]
	str	w19, [sp, 244]
	bl	GOMP_parallel
	b	.L1577
.L1665:
	adrp	x0, .LC37
	add	x0, x0, :lo12:.LC37
.LEHB102:
	bl	_ZSt20__throw_length_errorPKc
.LEHE102:
.L1664:
	adrp	x0, .LC37
	add	x0, x0, :lo12:.LC37
.LEHB103:
	bl	_ZSt20__throw_length_errorPKc
.LEHE103:
.L1623:
	mov	x19, x0
.L1609:
	cbz	x25, .L1611
.L1669:
	mov	x0, x25
	bl	_ZdlPv
.L1611:
	stp	d8, d9, [sp, 96]
	.cfi_offset 73, -5144
	.cfi_offset 72, -5152
	cbz	x21, .L1612
	mov	x0, x21
	bl	_ZdlPv
.L1612:
	mov	x0, x19
.LEHB104:
	bl	_Unwind_Resume
.LEHE104:
.L1622:
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 72
	.cfi_restore 73
	mov	x19, x0
	stp	x27, x28, [sp, 80]
	.cfi_offset 28, -5160
	.cfi_offset 27, -5168
	b	.L1611
.L1624:
	mov	x19, x0
	cbz	x20, .L1609
	mov	x0, x20
	bl	_ZdlPv
	cbnz	x25, .L1669
	b	.L1611
	.cfi_endproc
.LFE10431:
	.section	.gcc_except_table
.LLSDA10431:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE10431-.LLSDACSB10431
.LLSDACSB10431:
	.uleb128 .LEHB97-.LFB10431
	.uleb128 .LEHE97-.LEHB97
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB98-.LFB10431
	.uleb128 .LEHE98-.LEHB98
	.uleb128 .L1622-.LFB10431
	.uleb128 0
	.uleb128 .LEHB99-.LFB10431
	.uleb128 .LEHE99-.LEHB99
	.uleb128 .L1623-.LFB10431
	.uleb128 0
	.uleb128 .LEHB100-.LFB10431
	.uleb128 .LEHE100-.LEHB100
	.uleb128 .L1624-.LFB10431
	.uleb128 0
	.uleb128 .LEHB101-.LFB10431
	.uleb128 .LEHE101-.LEHB101
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB102-.LFB10431
	.uleb128 .LEHE102-.LEHB102
	.uleb128 .L1624-.LFB10431
	.uleb128 0
	.uleb128 .LEHB103-.LFB10431
	.uleb128 .LEHE103-.LEHB103
	.uleb128 .L1623-.LFB10431
	.uleb128 0
	.uleb128 .LEHB104-.LFB10431
	.uleb128 .LEHE104-.LEHB104
	.uleb128 0
	.uleb128 0
.LLSDACSE10431:
	.section	.text._ZN3ann14build_pq_indexEPKfmmiiiiRNS_7PQIndexE,"axG",@progbits,_ZN3ann14build_pq_indexEPKfmmiiiiRNS_7PQIndexE,comdat
	.size	_ZN3ann14build_pq_indexEPKfmmiiiiRNS_7PQIndexE, .-_ZN3ann14build_pq_indexEPKfmmiiiiRNS_7PQIndexE
	.section	.rodata.str1.8
	.align	3
.LC44:
	.string	"Unknown"
	.align	3
.LC45:
	.string	"/indices"
	.align	3
.LC46:
	.string	"/results/simd_results.csv"
	.align	3
.LC47:
	.string	"warning: failed to open "
	.align	3
.LC48:
	.string	"method,platform,N,d,Q,k,M,Ks,p,unroll,prefetch,topk,run_id,"
	.align	3
.LC49:
	.string	"latency_ms,recall,index_size_mb,build_time_sec,coarse_ms,rerank_ms,cycles,instructions,"
	.align	3
.LC50:
	.string	"cpi,l1_miss_rate,llc_miss_rate\n"
	.align	3
.LC51:
	.string	"ARM-aarch64-NEON"
	.align	3
.LC52:
	.string	"Flat-NEON-Unroll4-Prefetch-d"
	.align	3
.LC53:
	.string	"/indices/sq8.index"
	.align	3
.LC54:
	.string	"warning: failed to save SQ8 index\n"
	.align	3
.LC55:
	.string	"SQ8-rerank-p"
	.align	3
.LC56:
	.string	"SQ8-U8SIMD-rerank-p"
	.align	3
.LC57:
	.string	"/indices/pq_M"
	.align	3
.LC58:
	.string	"_Ks"
	.align	3
.LC59:
	.string	".index"
	.align	3
.LC60:
	.string	"warning: failed to save PQ index M="
	.align	3
.LC61:
	.string	"PQ-ADC-M"
	.align	3
.LC62:
	.string	"-p"
	.align	3
.LC63:
	.string	"wrote SIMD benchmark csv: "
	.text
	.align	2
	.p2align 4,,11
	.global	_Z20write_simd_benchmarkPfS_Pimmmmm
	.type	_Z20write_simd_benchmarkPfS_Pimmmmm, %function
_Z20write_simd_benchmarkPfS_Pimmmmm:
.LFB10471:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA10471
	sub	sp, sp, #2272
	.cfi_def_cfa_offset 2272
	add	x8, sp, 520
	stp	x29, x30, [sp, 64]
	.cfi_offset 29, -2208
	.cfi_offset 30, -2200
	add	x29, sp, 64
	stp	x19, x20, [sp, 80]
	stp	x21, x22, [sp, 96]
	stp	x23, x24, [sp, 112]
	stp	x25, x26, [sp, 128]
	.cfi_offset 19, -2192
	.cfi_offset 20, -2184
	.cfi_offset 21, -2176
	.cfi_offset 22, -2168
	.cfi_offset 23, -2160
	.cfi_offset 24, -2152
	.cfi_offset 25, -2144
	.cfi_offset 26, -2136
	mov	x26, x4
	stp	x27, x28, [sp, 144]
	.cfi_offset 27, -2128
	.cfi_offset 28, -2120
	mov	x28, x3
	mov	x27, x7
	stp	d8, d9, [sp, 160]
	.cfi_offset 72, -2112
	.cfi_offset 73, -2104
	stp	x0, x1, [sp, 232]
	stp	x2, x6, [sp, 248]
	str	x5, [sp, 304]
.LEHB105:
	bl	_Z13get_files_dirB5cxx11v
.LEHE105:
	add	x0, sp, 520
.LEHB106:
	bl	_Z10ensure_dirRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
	add	x25, sp, 1752
	adrp	x1, .LC15
	mov	x8, x25
	add	x1, x1, :lo12:.LC15
	add	x0, sp, 520
	bl	_ZStplIcSt11char_traitsIcESaIcEENSt7__cxx1112basic_stringIT_T0_T1_EERKS8_PKS5_
.LEHE106:
	mov	x0, x25
.LEHB107:
	bl	_Z10ensure_dirRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
.LEHE107:
	ldr	x0, [sp, 1752]
	add	x1, x25, 16
	cmp	x0, x1
	beq	.L1671
	bl	_ZdlPv
.L1671:
	adrp	x1, .LC45
	mov	x8, x25
	add	x1, x1, :lo12:.LC45
	add	x0, sp, 520
.LEHB108:
	bl	_ZStplIcSt11char_traitsIcESaIcEENSt7__cxx1112basic_stringIT_T0_T1_EERKS8_PKS5_
.LEHE108:
	mov	x0, x25
.LEHB109:
	bl	_Z10ensure_dirRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
.LEHE109:
	ldr	x0, [sp, 1752]
	add	x1, x25, 16
	cmp	x0, x1
	beq	.L1672
	bl	_ZdlPv
.L1672:
	ldp	x1, x2, [sp, 232]
	mov	x4, x26
	mov	x3, x28
	add	x0, sp, 520
.LEHB110:
	bl	_Z22write_alignment_reportRKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEEPKfS8_mm
	adrp	x1, .LC46
	add	x8, sp, 552
	add	x1, x1, :lo12:.LC46
	add	x0, sp, 520
	bl	_ZStplIcSt11char_traitsIcESaIcEENSt7__cxx1112basic_stringIT_T0_T1_EERKS8_PKS5_
.LEHE110:
	ldr	x1, [sp, 552]
	add	x0, sp, 1232
	mov	w2, 48
.LEHB111:
	bl	_ZNSt14basic_ofstreamIcSt11char_traitsIcEEC1EPKcSt13_Ios_Openmode
.LEHE111:
	add	x0, sp, 1352
	bl	_ZNKSt12__basic_fileIcE7is_openEv
	tst	w0, 255
	beq	.L1920
	adrp	x1, .LC48
	add	x0, sp, 1232
	add	x1, x1, :lo12:.LC48
.LEHB112:
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	adrp	x1, .LC49
	add	x1, x1, :lo12:.LC49
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	adrp	x1, .LC50
	add	x1, x1, :lo12:.LC50
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	ucvtf	d8, x28
	ucvtf	d1, x26
	fmov	d2, 4.0e+0
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d0, x0
	adrp	x0, .LANCHOR0
	add	x1, x0, :lo12:.LANCHOR0
	fmul	d8, d8, d1
	add	x24, sp, 584
	ldr	x0, [sp, 304]
	add	x2, x24, 32
	add	x3, sp, 704
	mov	x22, 100
	fmul	d8, d8, d2
	cmp	x0, 100
	csel	x22, x0, x22, ls
	adrp	x0, .LC44
	add	x0, x0, :lo12:.LC44
	stp	x0, x2, [sp, 192]
	mov	x2, x1
	fdiv	d8, d8, d0
	str	x1, [sp, 296]
	ldp	x0, x1, [x1]
	stp	x0, x1, [x3, -120]
	ldp	x0, x1, [x2, 16]
	stp	x0, x1, [x3, -104]
	.p2align 3,,7
.L1686:
	mov	w20, 1
.L1685:
	ldp	x1, x2, [sp, 240]
	mov	x0, 16
	ldr	w19, [x24]
	add	x8, sp, 856
	str	x0, [sp, 8]
	mov	x7, x27
	ldr	x0, [sp, 232]
	str	w19, [sp]
	ldr	x5, [sp, 256]
	mov	x6, x22
	mov	x4, x26
	mov	x3, x28
	bl	_Z10run_methodPfS_PimmmmmN3ann12SearchMethodEm
	cmp	w19, 9
	bhi	.L1677
	ldr	x0, [sp, 296]
	add	x1, x25, 16
	str	x1, [sp, 1752]
	add	x0, x0, 32
	ldr	x23, [x0, w19, uxtw 3]
	cbnz	x23, .L1678
	adrp	x0, .LC14
	add	x0, x0, :lo12:.LC14
	bl	_ZSt19__throw_logic_errorPKc
.LEHE112:
	.p2align 2,,3
.L1677:
	add	x1, x25, 16
	mov	x2, 7
	ldr	x23, [sp, 192]
	mov	x0, x1
	mov	x21, x2
	str	x2, [sp, 768]
	str	x1, [sp, 1752]
.L1679:
	mov	x2, x21
	mov	x1, x23
	bl	memcpy
	ldr	x2, [sp, 1752]
.L1681:
	ldr	x0, [sp, 768]
	str	x0, [sp, 1760]
	strb	wzr, [x2, x0]
	cmp	w19, 4
	beq	.L1808
.L1927:
	sub	w0, w19, #5
	mov	w1, 1
	cmp	w0, 2
	bls	.L1921
.L1682:
	adrp	x0, .LC12
	add	x0, x0, :lo12:.LC12
	mov	w3, 0
.L1683:
	movi	d1, #0
	fmov	d0, d8
	str	wzr, [sp]
	adrp	x2, .LC51
	str	wzr, [sp, 8]
	add	x2, x2, :lo12:.LC51
	str	w1, [sp, 16]
	mov	x6, x27
	str	w3, [sp, 24]
	mov	x5, x22
	str	x0, [sp, 32]
	add	x0, sp, 856
	str	w20, [sp, 40]
	mov	x4, x26
	str	x0, [sp, 48]
	mov	x3, x28
	mov	x1, x25
	add	x0, sp, 1232
	mov	w7, 0
	str	x2, [sp, 264]
.LEHB113:
	bl	_Z16write_result_rowRSt14basic_ofstreamIcSt11char_traitsIcEERKNSt7__cxx1112basic_stringIcS1_SaIcEEEPKcmmmmiiiiiSB_iRK12SearchResultdd
.LEHE113:
	ldr	x0, [sp, 1752]
	add	x1, x25, 16
	cmp	x0, x1
	beq	.L1684
	bl	_ZdlPv
.L1684:
	add	w20, w20, 1
	cmp	w20, 6
	bne	.L1685
	ldr	x0, [sp, 200]
	add	x24, x24, 4
	cmp	x0, x24
	bne	.L1686
	ldr	x2, [sp, 296]
	add	x0, sp, 440
	mov	x1, x0
	add	x3, sp, 512
	adrp	x0, _ZTVSt9basic_iosIcSt11char_traitsIcEE+16
	add	x0, x0, :lo12:_ZTVSt9basic_iosIcSt11char_traitsIcEE+16
	str	x1, [sp, 280]
	add	x1, x1, 20
	str	x0, [sp, 184]
	adrp	x23, _ZTTNSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEEE
	str	x1, [sp, 288]
	add	x23, x23, :lo12:_ZTTNSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEEE
	ldp	x0, x1, [x2, 112]
	stp	x0, x1, [x3, -72]
	ldr	w0, [x2, 128]
	str	w0, [sp, 456]
.L1701:
	ldr	x0, [sp, 280]
	mov	w20, 1
	ldr	w21, [x0]
	sxtw	x24, w21
.L1700:
	ldp	x1, x2, [sp, 240]
	mov	w0, 6
	str	w0, [sp]
	add	x8, sp, 768
	ldr	x0, [sp, 232]
	str	x24, [sp, 8]
	ldr	x5, [sp, 256]
	mov	x7, x27
	mov	x6, x22
	mov	x4, x26
	mov	x3, x28
.LEHB114:
	bl	_Z10run_methodPfS_PimmmmmN3ann12SearchMethodEm
.LEHE114:
	add	x0, x25, 112
	bl	_ZNSt8ios_baseC2Ev
	ldp	x19, x3, [x23, 8]
	strh	wzr, [sp, 2088]
	add	x15, sp, 2096
	mov	x1, 0
	ldr	x0, [sp, 184]
	str	x3, [sp, 200]
	ldr	x2, [x19, -24]
	str	x19, [sp, 1752]
	str	x0, [sp, 1864]
	str	xzr, [sp, 2080]
	add	x0, x25, x2
	stp	xzr, xzr, [x15]
	stp	xzr, xzr, [x15, 16]
	str	x3, [x25, x2]
.LEHB115:
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE4initEPSt15basic_streambufIcS1_E
.LEHE115:
	add	x13, sp, 1752
	add	x14, sp, 1784
	adrp	x1, _ZTVNSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEEE+24
	adrp	x0, _ZTVNSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEEE+64
	add	x2, x1, :lo12:_ZTVNSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEEE+24
	add	x3, x0, :lo12:_ZTVNSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEEE+64
	adrp	x1, _ZTVSt15basic_streambufIcSt11char_traitsIcEE+16
	add	x1, x1, :lo12:_ZTVSt15basic_streambufIcSt11char_traitsIcEE+16
	stp	x2, x1, [x13]
	add	x0, x25, 64
	stp	xzr, xzr, [x13, 16]
	stp	xzr, xzr, [x14]
	stp	xzr, xzr, [x14, 16]
	str	x1, [sp, 192]
	stp	x2, x3, [sp, 216]
	str	x3, [sp, 1864]
	bl	_ZNSt6localeC1Ev
	adrp	x2, _ZTVNSt7__cxx1115basic_stringbufIcSt11char_traitsIcESaIcEEE+16
	add	x2, x2, :lo12:_ZTVNSt7__cxx1115basic_stringbufIcSt11char_traitsIcESaIcEEE+16
	str	x2, [sp, 208]
	mov	w0, 16
	str	x2, [sp, 1760]
	add	x2, x25, 96
	add	x1, x25, 8
	str	w0, [sp, 1824]
	add	x0, x25, 112
	str	x2, [sp, 1832]
	str	xzr, [sp, 1840]
	strb	wzr, [sp, 1848]
.LEHB116:
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE4initEPSt15basic_streambufIcS1_E
.LEHE116:
	adrp	x1, .LC52
	mov	x0, x25
	add	x1, x1, :lo12:.LC52
	mov	x2, 28
.LEHB117:
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	mov	w1, w21
	mov	x0, x25
	bl	_ZNSolsEi
.LEHE117:
	ldr	x0, [sp, 1800]
	add	x1, sp, 872
	str	x1, [sp, 856]
	str	xzr, [sp, 864]
	strb	wzr, [sp, 872]
	cbz	x0, .L1691
	ldr	x4, [sp, 1784]
	ldr	x3, [sp, 1792]
	cmp	x0, x4
	bls	.L1692
	sub	x4, x0, x3
	mov	x2, 0
	add	x0, sp, 856
	mov	x1, 0
.LEHB118:
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE10_M_replaceEmmPKcm
.LEHE118:
.L1693:
	movi	d1, #0
	fmov	d0, d8
	ldr	x2, [sp, 264]
	mov	w0, 4
	adrp	x1, .LC12
	add	x1, x1, :lo12:.LC12
	str	wzr, [sp]
	mov	x6, x27
	str	wzr, [sp, 8]
	mov	x5, x22
	str	w0, [sp, 16]
	add	x0, sp, 768
	str	w21, [sp, 24]
	mov	x4, x26
	str	x1, [sp, 32]
	mov	x3, x28
	str	w20, [sp, 40]
	mov	w7, 0
	str	x0, [sp, 48]
	add	x0, sp, 1232
	str	x1, [sp, 272]
	add	x1, sp, 856
.LEHB119:
	bl	_Z16write_result_rowRSt14basic_ofstreamIcSt11char_traitsIcEERKNSt7__cxx1112basic_stringIcS1_SaIcEEEPKcmmmmiiiiiSB_iRK12SearchResultdd
.LEHE119:
	ldr	x0, [sp, 856]
	add	x1, sp, 872
	cmp	x0, x1
	beq	.L1698
	bl	_ZdlPv
.L1698:
	ldr	x2, [sp, 216]
	str	x2, [sp, 1752]
	ldr	x2, [sp, 208]
	str	x2, [sp, 1760]
	ldr	x0, [sp, 1832]
	add	x1, x25, 96
	ldr	x2, [sp, 224]
	str	x2, [sp, 1864]
	cmp	x0, x1
	beq	.L1699
	bl	_ZdlPv
.L1699:
	ldr	x1, [sp, 192]
	add	x0, x25, 64
	str	x1, [sp, 1760]
	add	w20, w20, 1
	bl	_ZNSt6localeD1Ev
	ldr	x1, [x19, -24]
	str	x19, [sp, 1752]
	ldr	x2, [sp, 200]
	add	x0, x25, 112
	str	x2, [x25, x1]
	ldr	x1, [sp, 184]
	str	x1, [sp, 1864]
	bl	_ZNSt8ios_baseD2Ev
	cmp	w20, 6
	bne	.L1700
	ldp	x0, x1, [sp, 280]
	add	x0, x0, 4
	str	x0, [sp, 280]
	cmp	x1, x0
	bne	.L1701
	ldp	x1, x4, [sp, 296]
	add	x11, sp, 696
	add	x12, sp, 728
	mov	x22, 20
	str	xzr, [sp, 760]
	stp	xzr, xzr, [x11]
	add	x0, x1, 136
	cmp	x4, 20
	ldp	x2, x3, [x1, 136]
	csel	x22, x4, x22, ls
	ldr	w0, [x0, 24]
	add	x4, sp, 704
	ldr	x1, [x1, 152]
	stp	xzr, xzr, [x12]
	stp	x2, x3, [x4, -216]
	stp	xzr, xzr, [x11, 16]
	stp	xzr, xzr, [x12, 16]
	str	x1, [sp, 504]
	str	w0, [sp, 512]
	bl	_Z6now_usv
	mov	x20, x0
	add	x3, sp, 680
	ldr	x0, [sp, 232]
	mov	x2, x26
	mov	x1, x28
.LEHB120:
	bl	_ZN3ann15build_sq8_indexEPKfmmRNS_8SQ8IndexE
	bl	_Z6now_usv
	sub	x0, x0, x20
	mov	x1, 145685290680320
	add	x8, sp, 856
	scvtf	d8, x0
	movk	x1, 0x412e, lsl 48
	fmov	d0, x1
	add	x0, sp, 520
	adrp	x1, .LC53
	add	x1, x1, :lo12:.LC53
	fdiv	d8, d8, d0
	bl	_ZStplIcSt11char_traitsIcESaIcEENSt7__cxx1112basic_stringIT_T0_T1_EERKS8_PKS5_
.LEHE120:
	ldr	x1, [sp, 856]
	mov	x0, x25
	mov	w2, 52
.LEHB121:
	bl	_ZNSt14basic_ofstreamIcSt11char_traitsIcEEC1EPKcSt13_Ios_Openmode
.LEHE121:
	add	x0, x25, 120
	bl	_ZNKSt12__basic_fileIcE7is_openEv
	tst	w0, 255
	bne	.L1922
	mov	x0, x25
	bl	_ZNSt14basic_ofstreamIcSt11char_traitsIcEED1Ev
	ldr	x0, [sp, 856]
	add	x1, sp, 872
	cmp	x0, x1
	beq	.L1707
	bl	_ZdlPv
.L1707:
	adrp	x1, .LC54
	adrp	x0, _ZSt4cerr
	add	x1, x1, :lo12:.LC54
	add	x0, x0, :lo12:_ZSt4cerr
.LEHB122:
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
.L1704:
	adrp	x0, .LC55
	add	x0, x0, :lo12:.LC55
	str	x0, [sp, 288]
	mov	x0, 145685290680320
	add	x1, sp, 488
	add	x2, sp, 516
	movk	x0, 0x412e, lsl 48
	fmov	d9, x0
	stp	x1, x1, [sp, 304]
	str	x2, [sp, 320]
	.p2align 3,,7
.L1722:
	ldr	x0, [sp, 304]
	add	x21, x25, 112
	add	x24, x25, 64
	mov	w20, 1
	ldr	w23, [x0]
	sxtw	x0, w23
	str	x0, [sp, 280]
.L1721:
	ldp	x1, x2, [sp, 232]
	add	x8, sp, 768
	ldp	x3, x4, [sp, 248]
	mov	x7, x27
	ldr	x6, [sp, 280]
	mov	x5, x22
	add	x0, sp, 680
	bl	_Z14run_sq8_methodRKN3ann8SQ8IndexEPfS3_Pimmmm
.LEHE122:
	mov	x0, x21
	bl	_ZNSt8ios_baseC2Ev
	strh	wzr, [sp, 2088]
	add	x10, sp, 2096
	ldr	x3, [sp, 200]
	mov	x1, 0
	ldr	x2, [x19, -24]
	str	x19, [sp, 1752]
	ldr	x0, [sp, 184]
	str	x0, [sp, 1864]
	str	xzr, [sp, 2080]
	add	x0, x25, x2
	stp	xzr, xzr, [x10]
	stp	xzr, xzr, [x10, 16]
	str	x3, [x25, x2]
.LEHB123:
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE4initEPSt15basic_streambufIcS1_E
.LEHE123:
	add	x9, sp, 1768
	mov	x0, x24
	ldr	x1, [sp, 216]
	str	x1, [sp, 1752]
	stp	xzr, xzr, [x9]
	stp	xzr, xzr, [x9, 16]
	ldr	x1, [sp, 192]
	str	x1, [sp, 1760]
	ldr	x1, [sp, 224]
	str	xzr, [sp, 1800]
	str	xzr, [sp, 1808]
	str	x1, [sp, 1864]
	bl	_ZNSt6localeC1Ev
	str	xzr, [sp, 1840]
	ldr	x2, [sp, 208]
	str	x2, [sp, 1760]
	add	x2, x25, 96
	mov	w0, 16
	add	x1, x25, 8
	str	w0, [sp, 1824]
	mov	x0, x21
	str	x2, [sp, 1832]
	strb	wzr, [sp, 1848]
.LEHB124:
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE4initEPSt15basic_streambufIcS1_E
.LEHE124:
	ldr	x1, [sp, 288]
	mov	x0, x25
	mov	x2, 12
.LEHB125:
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	mov	w1, w23
	mov	x0, x25
	bl	_ZNSolsEi
.LEHE125:
	ldr	x0, [sp, 1800]
	add	x1, sp, 872
	str	x1, [sp, 856]
	str	xzr, [sp, 864]
	strb	wzr, [sp, 872]
	cbz	x0, .L1712
	ldr	x4, [sp, 1784]
	ldr	x3, [sp, 1792]
	cmp	x0, x4
	bls	.L1713
	sub	x4, x0, x3
	mov	x2, 0
	add	x0, sp, 856
	mov	x1, 0
.LEHB126:
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE10_M_replaceEmmPKcm
.LEHE126:
.L1714:
	ldr	x1, [sp, 744]
	fmov	d3, 4.0e+0
	ldr	x2, [sp, 752]
	fmov	d1, d8
	ldr	x0, [sp, 720]
	sub	x2, x2, x1
	ldr	x1, [sp, 728]
	asr	x2, x2, 2
	ldr	x4, [sp, 696]
	sub	x1, x1, x0
	ldr	x0, [sp, 704]
	add	x1, x2, x1, asr 2
	ldr	x2, [sp, 264]
	ucvtf	d2, x1
	sub	x0, x0, x4
	mov	w3, 1
	str	wzr, [sp]
	mov	x6, x27
	ucvtf	d0, x0
	str	w23, [sp, 8]
	fmadd	d0, d2, d3, d0
	str	w3, [sp, 16]
	ldr	x0, [sp, 272]
	str	wzr, [sp, 24]
	str	x0, [sp, 32]
	add	x0, sp, 768
	str	w20, [sp, 40]
	mov	x5, x22
	str	x0, [sp, 48]
	add	x1, sp, 856
	mov	x4, x26
	mov	x3, x28
	add	x0, sp, 1232
	mov	w7, 0
	fdiv	d0, d0, d9
.LEHB127:
	bl	_Z16write_result_rowRSt14basic_ofstreamIcSt11char_traitsIcEERKNSt7__cxx1112basic_stringIcS1_SaIcEEEPKcmmmmiiiiiSB_iRK12SearchResultdd
.LEHE127:
	ldr	x0, [sp, 856]
	add	x1, sp, 872
	cmp	x0, x1
	beq	.L1719
	bl	_ZdlPv
.L1719:
	ldr	x2, [sp, 216]
	str	x2, [sp, 1752]
	ldr	x2, [sp, 208]
	str	x2, [sp, 1760]
	ldr	x0, [sp, 1832]
	add	x1, x25, 96
	ldr	x2, [sp, 224]
	str	x2, [sp, 1864]
	cmp	x0, x1
	beq	.L1720
	bl	_ZdlPv
.L1720:
	ldr	x1, [sp, 192]
	mov	x0, x24
	str	x1, [sp, 1760]
	add	w20, w20, 1
	bl	_ZNSt6localeD1Ev
	ldr	x1, [x19, -24]
	str	x19, [sp, 1752]
	ldr	x2, [sp, 200]
	mov	x0, x21
	str	x2, [x25, x1]
	ldr	x1, [sp, 184]
	str	x1, [sp, 1864]
	bl	_ZNSt8ios_baseD2Ev
	cmp	w20, 6
	bne	.L1721
	ldr	x0, [sp, 304]
	ldr	x1, [sp, 320]
	add	x0, x0, 4
	str	x0, [sp, 304]
	cmp	x1, x0
	bne	.L1722
	adrp	x0, .LC56
	add	x0, x0, :lo12:.LC56
	str	x0, [sp, 288]
	mov	x0, 145685290680320
	movk	x0, 0x412e, lsl 48
	fmov	d9, x0
	.p2align 3,,7
.L1736:
	ldr	x0, [sp, 312]
	add	x21, x25, 112
	add	x24, x25, 64
	mov	w20, 1
	ldr	w23, [x0]
	sxtw	x0, w23
	str	x0, [sp, 280]
.L1735:
	ldp	x1, x2, [sp, 232]
	add	x8, sp, 768
	ldp	x3, x4, [sp, 248]
	mov	x7, x27
	ldr	x6, [sp, 280]
	mov	x5, x22
	add	x0, sp, 680
.LEHB128:
	bl	_Z21run_sq8_u8simd_methodRKN3ann8SQ8IndexEPfS3_Pimmmm
.LEHE128:
	mov	x0, x21
	bl	_ZNSt8ios_baseC2Ev
	strh	wzr, [sp, 2088]
	add	x8, sp, 2096
	ldr	x0, [sp, 184]
	mov	x1, 0
	ldr	x2, [x19, -24]
	str	x19, [sp, 1752]
	ldr	x3, [sp, 200]
	str	x0, [sp, 1864]
	str	xzr, [sp, 2080]
	add	x0, x25, x2
	stp	xzr, xzr, [x8]
	stp	xzr, xzr, [x8, 16]
	str	x3, [x25, x2]
.LEHB129:
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE4initEPSt15basic_streambufIcS1_E
.LEHE129:
	add	x7, sp, 1768
	mov	x0, x24
	ldr	x1, [sp, 216]
	str	x1, [sp, 1752]
	stp	xzr, xzr, [x7]
	stp	xzr, xzr, [x7, 16]
	ldr	x1, [sp, 192]
	str	x1, [sp, 1760]
	ldr	x1, [sp, 224]
	str	xzr, [sp, 1800]
	str	xzr, [sp, 1808]
	str	x1, [sp, 1864]
	bl	_ZNSt6localeC1Ev
	str	xzr, [sp, 1840]
	ldr	x2, [sp, 208]
	str	x2, [sp, 1760]
	add	x2, x25, 96
	mov	w0, 16
	add	x1, x25, 8
	str	w0, [sp, 1824]
	mov	x0, x21
	str	x2, [sp, 1832]
	strb	wzr, [sp, 1848]
.LEHB130:
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE4initEPSt15basic_streambufIcS1_E
.LEHE130:
	ldr	x1, [sp, 288]
	mov	x0, x25
	mov	x2, 19
.LEHB131:
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	mov	w1, w23
	mov	x0, x25
	bl	_ZNSolsEi
.LEHE131:
	ldr	x0, [sp, 1800]
	add	x1, sp, 872
	str	x1, [sp, 856]
	str	xzr, [sp, 864]
	strb	wzr, [sp, 872]
	cbz	x0, .L1726
	ldr	x4, [sp, 1784]
	ldr	x3, [sp, 1792]
	cmp	x0, x4
	bls	.L1727
	sub	x4, x0, x3
	mov	x2, 0
	add	x0, sp, 856
	mov	x1, 0
.LEHB132:
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE10_M_replaceEmmPKcm
.LEHE132:
.L1728:
	ldr	x1, [sp, 744]
	fmov	d3, 4.0e+0
	ldr	x2, [sp, 752]
	fmov	d1, d8
	ldr	x0, [sp, 720]
	sub	x2, x2, x1
	ldr	x1, [sp, 728]
	asr	x2, x2, 2
	ldr	x4, [sp, 696]
	sub	x1, x1, x0
	ldr	x0, [sp, 704]
	add	x1, x2, x1, asr 2
	ldr	x2, [sp, 264]
	ucvtf	d2, x1
	sub	x0, x0, x4
	mov	w3, 1
	str	wzr, [sp]
	mov	x6, x27
	ucvtf	d0, x0
	str	w23, [sp, 8]
	fmadd	d0, d2, d3, d0
	str	w3, [sp, 16]
	ldr	x0, [sp, 272]
	str	wzr, [sp, 24]
	str	x0, [sp, 32]
	add	x0, sp, 768
	str	w20, [sp, 40]
	mov	x5, x22
	str	x0, [sp, 48]
	add	x1, sp, 856
	mov	x4, x26
	mov	x3, x28
	add	x0, sp, 1232
	mov	w7, 0
	fdiv	d0, d0, d9
.LEHB133:
	bl	_Z16write_result_rowRSt14basic_ofstreamIcSt11char_traitsIcEERKNSt7__cxx1112basic_stringIcS1_SaIcEEEPKcmmmmiiiiiSB_iRK12SearchResultdd
.LEHE133:
	ldr	x0, [sp, 856]
	add	x1, sp, 872
	cmp	x0, x1
	beq	.L1733
	bl	_ZdlPv
.L1733:
	ldr	x2, [sp, 216]
	str	x2, [sp, 1752]
	ldr	x2, [sp, 208]
	str	x2, [sp, 1760]
	ldr	x0, [sp, 1832]
	add	x1, x25, 96
	ldr	x2, [sp, 224]
	str	x2, [sp, 1864]
	cmp	x0, x1
	beq	.L1734
	bl	_ZdlPv
.L1734:
	ldr	x1, [sp, 192]
	mov	x0, x24
	str	x1, [sp, 1760]
	add	w20, w20, 1
	bl	_ZNSt6localeD1Ev
	ldr	x1, [x19, -24]
	str	x19, [sp, 1752]
	ldr	x2, [sp, 200]
	mov	x0, x21
	str	x2, [x25, x1]
	ldr	x1, [sp, 184]
	str	x1, [sp, 1864]
	bl	_ZNSt8ios_baseD2Ev
	cmp	w20, 6
	bne	.L1735
	ldp	x0, x1, [sp, 312]
	add	x0, x0, 4
	str	x0, [sp, 312]
	cmp	x1, x0
	bne	.L1736
	ldr	x2, [sp, 296]
	add	x0, sp, 424
	str	x0, [sp, 352]
	add	x0, sp, 436
	str	x0, [sp, 360]
	add	x0, sp, 664
	str	x0, [sp, 280]
	mov	w24, 8
	ldp	x0, x1, [x2, 168]
	stp	x0, x1, [sp, 464]
	ldr	w0, [x2, 184]
	mov	x2, 145685290680320
	str	w0, [sp, 480]
	movk	x2, 0x412e, lsl 48
	str	x2, [sp, 312]
	add	x2, sp, 512
	mov	x1, 12
	movk	x1, 0x10, lsl 32
	str	x1, [x2, -84]
.L1770:
	add	x6, sp, 808
	stp	xzr, xzr, [x6]
	stp	xzr, xzr, [x6, 16]
	str	xzr, [sp, 840]
	str	xzr, [sp, 848]
	bl	_Z6now_usv
	mov	x20, x0
	add	x7, sp, 768
	ldr	x0, [sp, 232]
	mov	w3, w24
	mov	x2, x26
	mov	x1, x28
	mov	w6, 10
	mov	w5, 2048
	mov	w4, 256
.LEHB134:
	bl	_ZN3ann14build_pq_indexEPKfmmiiiiRNS_7PQIndexE
	bl	_Z6now_usv
	sub	x1, x0, x20
	ldr	d1, [sp, 312]
	add	x0, sp, 856
	scvtf	d0, x1
	fdiv	d0, d0, d1
	str	d0, [sp, 320]
	bl	_ZNSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEEC1Ev
.LEHE134:
	ldr	x1, [sp, 520]
	add	x0, sp, 856
	ldr	x2, [sp, 528]
.LEHB135:
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	adrp	x1, .LC57
	add	x1, x1, :lo12:.LC57
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	mov	w1, w24
	bl	_ZNSolsEi
	adrp	x1, .LC58
	add	x1, x1, :lo12:.LC58
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	mov	w1, 256
	bl	_ZNSolsEi
	adrp	x1, .LC59
	add	x1, x1, :lo12:.LC59
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	add	x8, sp, 648
	add	x0, sp, 864
	bl	_ZNKSt7__cxx1115basic_stringbufIcSt11char_traitsIcESaIcEE3strEv
.LEHE135:
	add	x0, x25, 256
	ldr	x20, [sp, 648]
	bl	_ZNSt8ios_baseC2Ev
	adrp	x2, _ZTTSt14basic_ofstreamIcSt11char_traitsIcEE
	add	x2, x2, :lo12:_ZTTSt14basic_ofstreamIcSt11char_traitsIcEE
	strh	wzr, [sp, 2232]
	add	x5, sp, 2240
	ldr	x0, [sp, 184]
	mov	x1, 0
	ldp	x21, x23, [x2, 8]
	ldr	x3, [x21, -24]
	str	x21, [sp, 1752]
	str	x0, [sp, 2008]
	str	xzr, [sp, 2224]
	add	x0, x25, x3
	stp	xzr, xzr, [x5]
	stp	xzr, xzr, [x5, 16]
	str	x23, [x25, x3]
.LEHB136:
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE4initEPSt15basic_streambufIcS1_E
.LEHE136:
	adrp	x0, _ZTVSt14basic_ofstreamIcSt11char_traitsIcEE+64
	adrp	x1, _ZTVSt14basic_ofstreamIcSt11char_traitsIcEE+24
	add	x2, x0, :lo12:_ZTVSt14basic_ofstreamIcSt11char_traitsIcEE+64
	add	x1, x1, :lo12:_ZTVSt14basic_ofstreamIcSt11char_traitsIcEE+24
	add	x0, x25, 8
	stp	x1, x2, [sp, 288]
	str	x1, [sp, 1752]
	str	x2, [sp, 2008]
.LEHB137:
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEEC1Ev
.LEHE137:
	add	x1, x25, 8
	add	x0, x25, 256
.LEHB138:
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE4initEPSt15basic_streambufIcS1_E
	mov	x1, x20
	add	x0, x25, 8
	mov	w2, 52
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEE4openEPKcSt13_Ios_Openmode
	mov	x2, x0
	ldr	x0, [sp, 1752]
	ldr	x1, [x0, -24]
	add	x0, x25, x1
	cbz	x2, .L1923
	mov	w1, 0
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE5clearESt12_Ios_Iostate
.LEHE138:
.L1738:
	add	x0, x25, 120
	bl	_ZNKSt12__basic_fileIcE7is_openEv
	ands	w20, w0, 255
	beq	.L1740
	mov	w1, 20816
	movk	w1, 0x3144, lsl 16
	str	w1, [sp, 376]
	ldr	x1, [sp, 832]
	ldr	x3, [sp, 840]
	ldr	x2, [sp, 808]
	sub	x3, x3, x1
	str	x3, [sp, 616]
	ldr	w3, [sp, 788]
	str	w3, [sp, 384]
	ldr	w3, [sp, 792]
	ldr	x0, [sp, 816]
	str	w3, [sp, 388]
	ldr	w3, [sp, 796]
	str	w3, [sp, 392]
	sub	x0, x0, x2
	ldr	w3, [sp, 800]
	ldr	x2, [sp, 768]
	str	x2, [sp, 400]
	ldr	w2, [sp, 784]
	asr	x0, x0, 2
	ldr	x1, [sp, 776]
	str	w2, [sp, 380]
	mov	x2, 4
	str	w3, [sp, 396]
	str	x1, [sp, 408]
	add	x1, sp, 376
	str	x0, [sp, 416]
	mov	x0, x25
.LEHB139:
	bl	_ZNSo5writeEPKcl
	add	x1, sp, 400
	mov	x0, x25
	mov	x2, 8
	bl	_ZNSo5writeEPKcl
	add	x1, sp, 408
	mov	x0, x25
	mov	x2, 8
	bl	_ZNSo5writeEPKcl
	add	x1, sp, 380
	mov	x0, x25
	mov	x2, 4
	bl	_ZNSo5writeEPKcl
	add	x1, sp, 384
	mov	x0, x25
	mov	x2, 4
	bl	_ZNSo5writeEPKcl
	add	x1, sp, 388
	mov	x0, x25
	mov	x2, 4
	bl	_ZNSo5writeEPKcl
	add	x1, sp, 392
	mov	x0, x25
	mov	x2, 4
	bl	_ZNSo5writeEPKcl
	add	x1, sp, 396
	mov	x0, x25
	mov	x2, 4
	bl	_ZNSo5writeEPKcl
	add	x1, sp, 416
	mov	x0, x25
	mov	x2, 8
	bl	_ZNSo5writeEPKcl
	add	x1, sp, 616
	mov	x0, x25
	mov	x2, 8
	bl	_ZNSo5writeEPKcl
	ldr	x1, [sp, 808]
	mov	x0, x25
	ldr	x2, [sp, 816]
	sub	x2, x2, x1
	bl	_ZNSo5writeEPKcl
	ldr	x1, [sp, 832]
	mov	x0, x25
	ldr	x2, [sp, 840]
	sub	x2, x2, x1
	bl	_ZNSo5writeEPKcl
.LEHE139:
.L1740:
	ldp	x0, x1, [sp, 288]
	str	x0, [sp, 1752]
	str	x1, [sp, 2008]
	adrp	x0, _ZTVSt13basic_filebufIcSt11char_traitsIcEE+16
	add	x0, x0, :lo12:_ZTVSt13basic_filebufIcSt11char_traitsIcEE+16
	str	x0, [sp, 1760]
	add	x0, x25, 8
.LEHB140:
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEE5closeEv
.LEHE140:
.L1748:
	add	x0, x25, 120
	bl	_ZNSt12__basic_fileIcED1Ev
	ldr	x1, [sp, 192]
	add	x0, x25, 64
	str	x1, [sp, 1760]
	bl	_ZNSt6localeD1Ev
	ldr	x1, [x21, -24]
	str	x21, [sp, 1752]
	add	x0, x25, 256
	str	x23, [x25, x1]
	ldr	x1, [sp, 184]
	str	x1, [sp, 2008]
	bl	_ZNSt8ios_baseD2Ev
	ldr	x1, [sp, 280]
	ldr	x0, [sp, 648]
	cmp	x0, x1
	beq	.L1746
	bl	_ZdlPv
.L1746:
	cbz	w20, .L1924
.L1750:
	add	x0, sp, 464
	add	x21, sp, 616
	mov	x1, x0
	adrp	x0, .LC61
	add	x0, x0, :lo12:.LC61
	stp	x0, x1, [sp, 328]
	add	x1, x1, 20
	str	x1, [sp, 344]
.L1765:
	ldr	x0, [sp, 336]
	mov	w20, 1
	ldr	w23, [x0]
	adrp	x0, .LC62
	add	x0, x0, :lo12:.LC62
	str	x0, [sp, 304]
	sxtw	x0, w23
	str	x0, [sp, 296]
.L1764:
	ldp	x1, x2, [sp, 232]
	mov	x8, x21
	ldp	x3, x4, [sp, 248]
	mov	x7, x27
	ldr	x6, [sp, 296]
	mov	x5, x22
	add	x0, sp, 768
.LEHB141:
	bl	_Z13run_pq_methodRKN3ann7PQIndexEPfS3_Pimmmm
.LEHE141:
	add	x0, x25, 112
	bl	_ZNSt8ios_baseC2Ev
	strh	wzr, [sp, 2088]
	add	x4, sp, 2096
	ldr	x0, [sp, 184]
	mov	x1, 0
	ldr	x2, [x19, -24]
	str	x19, [sp, 1752]
	ldr	x3, [sp, 200]
	str	x0, [sp, 1864]
	str	xzr, [sp, 2080]
	add	x0, x25, x2
	stp	xzr, xzr, [x4]
	stp	xzr, xzr, [x4, 16]
	str	x3, [x25, x2]
.LEHB142:
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE4initEPSt15basic_streambufIcS1_E
.LEHE142:
	ldr	x1, [sp, 216]
	str	x1, [sp, 1752]
	add	x1, sp, 1768
	add	x0, x25, 64
	stp	xzr, xzr, [x1]
	stp	xzr, xzr, [x1, 16]
	ldr	x1, [sp, 192]
	str	x1, [sp, 1760]
	ldr	x1, [sp, 224]
	str	xzr, [sp, 1800]
	str	xzr, [sp, 1808]
	str	x1, [sp, 1864]
	bl	_ZNSt6localeC1Ev
	str	xzr, [sp, 1840]
	ldr	x2, [sp, 208]
	str	x2, [sp, 1760]
	add	x2, x25, 96
	mov	w0, 16
	add	x1, x25, 8
	str	w0, [sp, 1824]
	add	x0, x25, 112
	str	x2, [sp, 1832]
	strb	wzr, [sp, 1848]
.LEHB143:
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE4initEPSt15basic_streambufIcS1_E
.LEHE143:
	ldr	x1, [sp, 328]
	mov	x0, x25
	mov	x2, 8
.LEHB144:
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	mov	w1, w24
	mov	x0, x25
	bl	_ZNSolsEi
	ldr	x1, [sp, 304]
	mov	x2, 2
	str	x0, [sp, 288]
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	ldr	x0, [sp, 288]
	mov	w1, w23
	bl	_ZNSolsEi
.LEHE144:
	ldr	x0, [sp, 1800]
	str	xzr, [sp, 656]
	ldr	x1, [sp, 280]
	str	x1, [sp, 648]
	strb	wzr, [sp, 664]
	cbz	x0, .L1755
	ldr	x4, [sp, 1784]
	ldr	x3, [sp, 1792]
	cmp	x0, x4
	bls	.L1756
	sub	x4, x0, x3
	mov	x2, 0
	add	x0, sp, 648
	mov	x1, 0
.LEHB145:
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE10_M_replaceEmmPKcm
.LEHE145:
.L1757:
	ldr	x0, [sp, 808]
	fmov	d3, 4.0e+0
	ldr	x1, [sp, 816]
	mov	w2, 1
	ldr	x3, [sp, 832]
	sub	x1, x1, x0
	fmov	d0, x1
	str	w2, [sp, 16]
	ldr	x0, [sp, 840]
	sshr	d2, d0, 2
	ldr	x2, [sp, 264]
	sub	x0, x0, x3
	ldr	d1, [sp, 320]
	mov	w1, 256
	ucvtf	d2, d2
	ucvtf	d0, x0
	ldr	x0, [sp, 272]
	str	w1, [sp]
	str	w23, [sp, 8]
	mov	w7, w24
	fmadd	d0, d2, d3, d0
	ldr	d2, [sp, 312]
	str	wzr, [sp, 24]
	mov	x6, x27
	str	x0, [sp, 32]
	mov	x5, x22
	str	w20, [sp, 40]
	mov	x4, x26
	str	x21, [sp, 48]
	mov	x3, x28
	add	x1, sp, 648
	add	x0, sp, 1232
	fdiv	d0, d0, d2
.LEHB146:
	bl	_Z16write_result_rowRSt14basic_ofstreamIcSt11char_traitsIcEERKNSt7__cxx1112basic_stringIcS1_SaIcEEEPKcmmmmiiiiiSB_iRK12SearchResultdd
.LEHE146:
	ldr	x1, [sp, 280]
	ldr	x0, [sp, 648]
	cmp	x0, x1
	beq	.L1762
	bl	_ZdlPv
.L1762:
	ldr	x2, [sp, 216]
	str	x2, [sp, 1752]
	ldr	x2, [sp, 208]
	str	x2, [sp, 1760]
	ldr	x0, [sp, 1832]
	add	x1, x25, 96
	ldr	x2, [sp, 224]
	str	x2, [sp, 1864]
	cmp	x0, x1
	beq	.L1763
	bl	_ZdlPv
.L1763:
	ldr	x1, [sp, 192]
	add	x0, x25, 64
	str	x1, [sp, 1760]
	add	w20, w20, 1
	bl	_ZNSt6localeD1Ev
	ldr	x1, [x19, -24]
	str	x19, [sp, 1752]
	ldr	x2, [sp, 200]
	add	x0, x25, 112
	str	x2, [x25, x1]
	ldr	x1, [sp, 184]
	str	x1, [sp, 1864]
	bl	_ZNSt8ios_baseD2Ev
	cmp	w20, 6
	bne	.L1764
	ldp	x0, x1, [sp, 336]
	add	x0, x0, 4
	str	x0, [sp, 336]
	cmp	x1, x0
	bne	.L1765
	ldr	x2, [sp, 216]
	str	x2, [sp, 856]
	ldr	x2, [sp, 208]
	str	x2, [sp, 864]
	ldr	x0, [sp, 936]
	add	x1, sp, 952
	ldr	x2, [sp, 224]
	str	x2, [sp, 968]
	cmp	x0, x1
	beq	.L1766
	bl	_ZdlPv
.L1766:
	ldr	x1, [sp, 192]
	add	x0, sp, 920
	str	x1, [sp, 864]
	bl	_ZNSt6localeD1Ev
	ldr	x1, [x19, -24]
	add	x2, sp, 856
	str	x19, [sp, 856]
	add	x0, sp, 968
	ldr	x3, [sp, 200]
	str	x3, [x2, x1]
	ldr	x1, [sp, 184]
	str	x1, [sp, 968]
	bl	_ZNSt8ios_baseD2Ev
	ldr	x0, [sp, 832]
	cbz	x0, .L1767
	bl	_ZdlPv
.L1767:
	ldr	x0, [sp, 808]
	cbz	x0, .L1768
	bl	_ZdlPv
.L1768:
	ldp	x0, x1, [sp, 352]
	add	x0, x0, 4
	str	x0, [sp, 352]
	cmp	x1, x0
	beq	.L1769
	ldr	w24, [x0]
	b	.L1770
	.p2align 2,,3
.L1678:
	mov	x0, x23
	str	x1, [sp, 184]
	bl	strlen
	str	x0, [sp, 768]
	mov	x21, x0
	cmp	x0, 15
	ldr	x1, [sp, 184]
	bls	.L1925
	add	x1, sp, 768
	mov	x0, x25
	mov	x2, 0
.LEHB147:
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE9_M_createERmm
.LEHE147:
	ldr	x1, [sp, 768]
	str	x0, [sp, 1752]
	str	x1, [sp, 1768]
	b	.L1679
	.p2align 2,,3
.L1692:
	sub	x4, x4, x3
	add	x0, sp, 856
	mov	x2, 0
	mov	x1, 0
.LEHB148:
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE10_M_replaceEmmPKcm
	b	.L1693
	.p2align 2,,3
.L1921:
	sub	w0, w19, #6
	cmp	w0, w1
	bhi	.L1810
	cmp	w19, 7
	bne	.L1926
	adrp	x0, .LC11
	mov	w1, 4
	add	x0, x0, :lo12:.LC11
	mov	w3, 16
	b	.L1683
	.p2align 2,,3
.L1925:
	cmp	x21, 1
	bne	.L1680
	ldrb	w0, [x23]
	mov	x2, x1
	strb	w0, [sp, 1768]
	ldr	x0, [sp, 768]
	str	x0, [sp, 1760]
	strb	wzr, [x2, x0]
	cmp	w19, 4
	bne	.L1927
.L1808:
	mov	w1, 2
	b	.L1682
	.p2align 2,,3
.L1680:
	mov	x2, x1
	cbz	x21, .L1681
	mov	x0, x1
	b	.L1679
	.p2align 2,,3
.L1691:
	add	x1, x25, 80
	add	x0, sp, 856
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE9_M_assignERKS4_
.LEHE148:
	b	.L1693
	.p2align 2,,3
.L1810:
	adrp	x0, .LC12
	mov	w1, 4
	add	x0, x0, :lo12:.LC12
	mov	w3, 0
	b	.L1683
.L1922:
	mov	w2, 20819
	ldr	x1, [sp, 696]
	movk	w2, 0x3851, lsl 16
	ldr	x0, [sp, 704]
	str	w2, [sp, 464]
	ldr	x2, [sp, 680]
	sub	x0, x0, x1
	ldr	x1, [sp, 688]
	str	x2, [sp, 616]
	mov	x2, 4
	str	x1, [sp, 648]
	add	x1, sp, 464
	str	x0, [sp, 768]
	mov	x0, x25
.LEHB149:
	bl	_ZNSo5writeEPKcl
	add	x1, sp, 616
	mov	x0, x25
	mov	x2, 8
	bl	_ZNSo5writeEPKcl
	add	x1, sp, 648
	mov	x0, x25
	mov	x2, 8
	bl	_ZNSo5writeEPKcl
	add	x1, sp, 768
	mov	x0, x25
	mov	x2, 8
	bl	_ZNSo5writeEPKcl
	ldr	x1, [sp, 696]
	mov	x0, x25
	ldr	x2, [sp, 704]
	sub	x2, x2, x1
	bl	_ZNSo5writeEPKcl
	ldr	x1, [sp, 720]
	mov	x0, x25
	ldr	x2, [sp, 728]
	sub	x2, x2, x1
	bl	_ZNSo5writeEPKcl
	ldr	x1, [sp, 744]
	mov	x0, x25
	ldr	x2, [sp, 752]
	sub	x2, x2, x1
	bl	_ZNSo5writeEPKcl
.LEHE149:
	mov	x0, x25
	bl	_ZNSt14basic_ofstreamIcSt11char_traitsIcEED1Ev
	ldr	x0, [sp, 856]
	add	x1, sp, 872
	cmp	x0, x1
	beq	.L1704
	bl	_ZdlPv
	b	.L1704
	.p2align 2,,3
.L1756:
	sub	x4, x4, x3
	add	x0, sp, 648
	mov	x2, 0
	mov	x1, 0
.LEHB150:
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE10_M_replaceEmmPKcm
.LEHE150:
	b	.L1757
	.p2align 2,,3
.L1713:
	sub	x4, x4, x3
	add	x0, sp, 856
	mov	x2, 0
	mov	x1, 0
.LEHB151:
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE10_M_replaceEmmPKcm
.LEHE151:
	b	.L1714
	.p2align 2,,3
.L1727:
	sub	x4, x4, x3
	add	x0, sp, 856
	mov	x2, 0
	mov	x1, 0
.LEHB152:
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE10_M_replaceEmmPKcm
.LEHE152:
	b	.L1728
	.p2align 2,,3
.L1755:
	add	x1, x25, 80
	add	x0, sp, 648
.LEHB153:
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE9_M_assignERKS4_
.LEHE153:
	b	.L1757
	.p2align 2,,3
.L1712:
	add	x1, x25, 80
	add	x0, sp, 856
.LEHB154:
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE9_M_assignERKS4_
.LEHE154:
	b	.L1714
	.p2align 2,,3
.L1726:
	add	x1, x25, 80
	add	x0, sp, 856
.LEHB155:
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE9_M_assignERKS4_
.LEHE155:
	b	.L1728
	.p2align 2,,3
.L1769:
	add	x0, sp, 1240
.LEHB156:
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEE5closeEv
	cbz	x0, .L1928
.L1771:
	adrp	x1, .LC63
	adrp	x0, _ZSt4cerr
	add	x1, x1, :lo12:.LC63
	add	x0, x0, :lo12:_ZSt4cerr
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	ldr	x1, [sp, 552]
	ldr	x2, [sp, 560]
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	adrp	x1, .LC10
	add	x1, x1, :lo12:.LC10
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
.LEHE156:
	ldr	x0, [sp, 744]
	cbz	x0, .L1772
	bl	_ZdlPv
.L1772:
	ldr	x0, [sp, 720]
	cbz	x0, .L1773
	bl	_ZdlPv
.L1773:
	ldr	x0, [sp, 696]
	cbz	x0, .L1774
	bl	_ZdlPv
.L1774:
	add	x0, sp, 1232
	bl	_ZNSt14basic_ofstreamIcSt11char_traitsIcEED1Ev
	ldr	x0, [sp, 552]
	add	x1, sp, 568
	cmp	x0, x1
	beq	.L1775
	bl	_ZdlPv
.L1775:
	ldr	x0, [sp, 520]
	add	x1, sp, 536
	cmp	x0, x1
	beq	.L1670
	bl	_ZdlPv
.L1670:
	ldp	x29, x30, [sp, 64]
	ldp	x19, x20, [sp, 80]
	ldp	x21, x22, [sp, 96]
	ldp	x23, x24, [sp, 112]
	ldp	x25, x26, [sp, 128]
	ldp	x27, x28, [sp, 144]
	ldp	d8, d9, [sp, 160]
	add	sp, sp, 2272
	.cfi_remember_state
	.cfi_restore 29
	.cfi_restore 30
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_restore 72
	.cfi_restore 73
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L1924:
	.cfi_restore_state
	adrp	x1, .LC60
	adrp	x0, _ZSt4cerr
	add	x1, x1, :lo12:.LC60
	add	x0, x0, :lo12:_ZSt4cerr
.LEHB157:
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	mov	w1, w24
	bl	_ZNSolsEi
	adrp	x1, .LC10
	add	x1, x1, :lo12:.LC10
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
.LEHE157:
	b	.L1750
	.p2align 2,,3
.L1923:
	ldr	w1, [x0, 32]
	orr	w1, w1, 4
.LEHB158:
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE5clearESt12_Ios_Iostate
.LEHE158:
	b	.L1738
.L1920:
	adrp	x1, .LC47
	adrp	x0, _ZSt4cerr
	add	x1, x1, :lo12:.LC47
	add	x0, x0, :lo12:_ZSt4cerr
.LEHB159:
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	ldr	x1, [sp, 552]
	ldr	x2, [sp, 560]
	bl	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
	adrp	x1, .LC10
	add	x1, x1, :lo12:.LC10
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
.LEHE159:
	b	.L1774
.L1928:
	ldr	x0, [sp, 1232]
	add	x1, sp, 1232
	ldr	x0, [x0, -24]
	add	x0, x1, x0
	ldr	w1, [x0, 32]
	orr	w1, w1, 4
.LEHB160:
	bl	_ZNSt9basic_iosIcSt11char_traitsIcEE5clearESt12_Ios_Iostate
.LEHE160:
	b	.L1771
.L1926:
	adrp	x0, .LC12
	mov	w1, 4
	add	x0, x0, :lo12:.LC12
	mov	w3, 16
	b	.L1683
.L1824:
	mov	x19, x0
.L1732:
	mov	x0, x25
	bl	_ZNSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEED1Ev
.L1711:
	ldr	x0, [sp, 744]
	cbz	x0, .L1797
	bl	_ZdlPv
.L1797:
	ldr	x0, [sp, 720]
	cbz	x0, .L1798
	bl	_ZdlPv
.L1798:
	ldr	x0, [sp, 696]
	cbnz	x0, .L1929
.L1690:
	add	x0, sp, 1232
	bl	_ZNSt14basic_ofstreamIcSt11char_traitsIcEED1Ev
.L1800:
	ldr	x0, [sp, 552]
	add	x1, sp, 568
	cmp	x0, x1
	beq	.L1779
	bl	_ZdlPv
.L1779:
	ldr	x0, [sp, 520]
	add	x1, sp, 536
	cmp	x0, x1
	beq	.L1802
	bl	_ZdlPv
.L1802:
	mov	x0, x19
.LEHB161:
	bl	_Unwind_Resume
.LEHE161:
.L1839:
.L1915:
	ldr	x1, [sp, 856]
	add	x2, sp, 872
	mov	x19, x0
	cmp	x1, x2
	beq	.L1732
	mov	x0, x1
	bl	_ZdlPv
	b	.L1732
.L1929:
	bl	_ZdlPv
	b	.L1690
.L1825:
	b	.L1915
.L1826:
	mov	x19, x0
	b	.L1794
.L1838:
.L1906:
	mov	x20, x0
	add	x0, x25, 8
	bl	_ZNSt7__cxx1115basic_stringbufIcSt11char_traitsIcESaIcEED1Ev
	ldr	x0, [x19, -24]
	str	x19, [sp, 1752]
	mov	x19, x20
	ldr	x1, [sp, 200]
	str	x1, [x25, x0]
.L1725:
	ldr	x1, [sp, 184]
	add	x0, x25, 112
	str	x1, [sp, 1864]
	bl	_ZNSt8ios_baseD2Ev
	b	.L1711
.L1827:
	mov	x19, x0
	b	.L1754
.L1828:
	mov	x19, x0
.L1761:
	mov	x0, x25
	bl	_ZNSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEED1Ev
	b	.L1754
.L1830:
	mov	x19, x0
.L1689:
	ldr	x1, [sp, 184]
	add	x0, x25, 112
	str	x1, [sp, 1864]
	bl	_ZNSt8ios_baseD2Ev
	b	.L1690
.L1835:
	b	.L1906
.L1819:
.L1911:
	ldr	x1, [sp, 856]
	add	x2, sp, 872
	mov	x19, x0
	cmp	x1, x2
	beq	.L1697
	mov	x0, x1
	bl	_ZdlPv
.L1697:
	mov	x0, x25
	bl	_ZNSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEED1Ev
	b	.L1690
.L1832:
	b	.L1911
.L1818:
	mov	x19, x0
	b	.L1697
.L1831:
	mov	x20, x0
	add	x0, x25, 8
	bl	_ZNSt7__cxx1115basic_stringbufIcSt11char_traitsIcESaIcEED1Ev
	ldr	x0, [x19, -24]
	str	x19, [sp, 1752]
	ldr	x1, [sp, 200]
	mov	x19, x20
	str	x1, [x25, x0]
	b	.L1689
.L1842:
	mov	x19, x0
.L1742:
	ldr	x0, [x21, -24]
	str	x21, [sp, 1752]
	str	x23, [x25, x0]
.L1743:
	ldr	x1, [sp, 184]
	add	x0, x25, 256
	str	x1, [sp, 2008]
	bl	_ZNSt8ios_baseD2Ev
.L1744:
	ldr	x0, [sp, 648]
	add	x1, sp, 664
	cmp	x0, x1
	beq	.L1754
	bl	_ZdlPv
.L1754:
	add	x0, sp, 856
	bl	_ZNSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEED1Ev
.L1794:
	ldr	x0, [sp, 832]
	cbz	x0, .L1795
	bl	_ZdlPv
.L1795:
	ldr	x0, [sp, 808]
	cbz	x0, .L1711
	bl	_ZdlPv
	b	.L1711
.L1820:
	mov	x19, x0
	b	.L1711
.L1841:
	mov	x19, x0
	b	.L1743
.L1840:
	mov	x19, x0
	mov	x0, x25
	bl	_ZNSt14basic_ofstreamIcSt11char_traitsIcEED1Ev
	b	.L1744
.L1844:
	bl	__cxa_begin_catch
	bl	__cxa_end_catch
	b	.L1748
.L1816:
	mov	x19, x0
	b	.L1690
.L1843:
	mov	x19, x0
	add	x0, x25, 8
	bl	_ZNSt13basic_filebufIcSt11char_traitsIcEED1Ev
	b	.L1742
.L1817:
	ldr	x1, [sp, 1752]
	add	x2, x25, 16
	mov	x19, x0
	cmp	x1, x2
	beq	.L1690
	mov	x0, x1
	bl	_ZdlPv
	b	.L1690
.L1845:
	mov	x19, x0
.L1753:
	ldr	x1, [sp, 184]
	add	x0, x25, 112
	str	x1, [sp, 1864]
	bl	_ZNSt8ios_baseD2Ev
	b	.L1754
.L1846:
	mov	x20, x0
	add	x0, x25, 8
	bl	_ZNSt7__cxx1115basic_stringbufIcSt11char_traitsIcESaIcEED1Ev
	ldr	x0, [x19, -24]
	str	x19, [sp, 1752]
	ldr	x1, [sp, 200]
	mov	x19, x20
	str	x1, [x25, x0]
	b	.L1753
.L1813:
.L1909:
	ldr	x1, [sp, 1752]
	add	x2, x25, 16
	mov	x19, x0
	cmp	x1, x2
	beq	.L1779
	mov	x0, x1
	bl	_ZdlPv
	b	.L1779
.L1815:
	mov	x19, x0
	b	.L1800
.L1821:
	mov	x19, x0
.L1706:
	ldr	x0, [sp, 856]
	add	x1, sp, 872
	cmp	x0, x1
	beq	.L1711
	bl	_ZdlPv
	b	.L1711
.L1834:
	mov	x19, x0
	b	.L1725
.L1829:
	ldr	x2, [sp, 648]
	add	x1, sp, 664
	mov	x19, x0
	cmp	x2, x1
	beq	.L1761
	mov	x0, x2
	bl	_ZdlPv
	b	.L1761
.L1847:
	ldr	x1, [sp, 648]
	add	x2, sp, 664
	mov	x19, x0
	cmp	x1, x2
	beq	.L1761
	mov	x0, x1
	bl	_ZdlPv
	b	.L1761
.L1814:
	b	.L1909
.L1836:
	b	.L1915
.L1837:
	mov	x19, x0
	b	.L1725
.L1823:
	b	.L1915
.L1833:
	mov	x19, x0
	mov	x0, x25
	bl	_ZNSt14basic_ofstreamIcSt11char_traitsIcEED1Ev
	b	.L1706
.L1822:
	mov	x19, x0
	b	.L1732
.L1812:
	mov	x19, x0
	b	.L1779
	.cfi_endproc
.LFE10471:
	.section	.gcc_except_table
	.align	2
.LLSDA10471:
	.byte	0xff
	.byte	0x9b
	.uleb128 .LLSDATT10471-.LLSDATTD10471
.LLSDATTD10471:
	.byte	0x1
	.uleb128 .LLSDACSE10471-.LLSDACSB10471
.LLSDACSB10471:
	.uleb128 .LEHB105-.LFB10471
	.uleb128 .LEHE105-.LEHB105
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB106-.LFB10471
	.uleb128 .LEHE106-.LEHB106
	.uleb128 .L1812-.LFB10471
	.uleb128 0
	.uleb128 .LEHB107-.LFB10471
	.uleb128 .LEHE107-.LEHB107
	.uleb128 .L1813-.LFB10471
	.uleb128 0
	.uleb128 .LEHB108-.LFB10471
	.uleb128 .LEHE108-.LEHB108
	.uleb128 .L1812-.LFB10471
	.uleb128 0
	.uleb128 .LEHB109-.LFB10471
	.uleb128 .LEHE109-.LEHB109
	.uleb128 .L1814-.LFB10471
	.uleb128 0
	.uleb128 .LEHB110-.LFB10471
	.uleb128 .LEHE110-.LEHB110
	.uleb128 .L1812-.LFB10471
	.uleb128 0
	.uleb128 .LEHB111-.LFB10471
	.uleb128 .LEHE111-.LEHB111
	.uleb128 .L1815-.LFB10471
	.uleb128 0
	.uleb128 .LEHB112-.LFB10471
	.uleb128 .LEHE112-.LEHB112
	.uleb128 .L1816-.LFB10471
	.uleb128 0
	.uleb128 .LEHB113-.LFB10471
	.uleb128 .LEHE113-.LEHB113
	.uleb128 .L1817-.LFB10471
	.uleb128 0
	.uleb128 .LEHB114-.LFB10471
	.uleb128 .LEHE114-.LEHB114
	.uleb128 .L1816-.LFB10471
	.uleb128 0
	.uleb128 .LEHB115-.LFB10471
	.uleb128 .LEHE115-.LEHB115
	.uleb128 .L1830-.LFB10471
	.uleb128 0
	.uleb128 .LEHB116-.LFB10471
	.uleb128 .LEHE116-.LEHB116
	.uleb128 .L1831-.LFB10471
	.uleb128 0
	.uleb128 .LEHB117-.LFB10471
	.uleb128 .LEHE117-.LEHB117
	.uleb128 .L1818-.LFB10471
	.uleb128 0
	.uleb128 .LEHB118-.LFB10471
	.uleb128 .LEHE118-.LEHB118
	.uleb128 .L1832-.LFB10471
	.uleb128 0
	.uleb128 .LEHB119-.LFB10471
	.uleb128 .LEHE119-.LEHB119
	.uleb128 .L1819-.LFB10471
	.uleb128 0
	.uleb128 .LEHB120-.LFB10471
	.uleb128 .LEHE120-.LEHB120
	.uleb128 .L1820-.LFB10471
	.uleb128 0
	.uleb128 .LEHB121-.LFB10471
	.uleb128 .LEHE121-.LEHB121
	.uleb128 .L1821-.LFB10471
	.uleb128 0
	.uleb128 .LEHB122-.LFB10471
	.uleb128 .LEHE122-.LEHB122
	.uleb128 .L1820-.LFB10471
	.uleb128 0
	.uleb128 .LEHB123-.LFB10471
	.uleb128 .LEHE123-.LEHB123
	.uleb128 .L1834-.LFB10471
	.uleb128 0
	.uleb128 .LEHB124-.LFB10471
	.uleb128 .LEHE124-.LEHB124
	.uleb128 .L1835-.LFB10471
	.uleb128 0
	.uleb128 .LEHB125-.LFB10471
	.uleb128 .LEHE125-.LEHB125
	.uleb128 .L1822-.LFB10471
	.uleb128 0
	.uleb128 .LEHB126-.LFB10471
	.uleb128 .LEHE126-.LEHB126
	.uleb128 .L1836-.LFB10471
	.uleb128 0
	.uleb128 .LEHB127-.LFB10471
	.uleb128 .LEHE127-.LEHB127
	.uleb128 .L1823-.LFB10471
	.uleb128 0
	.uleb128 .LEHB128-.LFB10471
	.uleb128 .LEHE128-.LEHB128
	.uleb128 .L1820-.LFB10471
	.uleb128 0
	.uleb128 .LEHB129-.LFB10471
	.uleb128 .LEHE129-.LEHB129
	.uleb128 .L1837-.LFB10471
	.uleb128 0
	.uleb128 .LEHB130-.LFB10471
	.uleb128 .LEHE130-.LEHB130
	.uleb128 .L1838-.LFB10471
	.uleb128 0
	.uleb128 .LEHB131-.LFB10471
	.uleb128 .LEHE131-.LEHB131
	.uleb128 .L1824-.LFB10471
	.uleb128 0
	.uleb128 .LEHB132-.LFB10471
	.uleb128 .LEHE132-.LEHB132
	.uleb128 .L1839-.LFB10471
	.uleb128 0
	.uleb128 .LEHB133-.LFB10471
	.uleb128 .LEHE133-.LEHB133
	.uleb128 .L1825-.LFB10471
	.uleb128 0
	.uleb128 .LEHB134-.LFB10471
	.uleb128 .LEHE134-.LEHB134
	.uleb128 .L1826-.LFB10471
	.uleb128 0
	.uleb128 .LEHB135-.LFB10471
	.uleb128 .LEHE135-.LEHB135
	.uleb128 .L1827-.LFB10471
	.uleb128 0
	.uleb128 .LEHB136-.LFB10471
	.uleb128 .LEHE136-.LEHB136
	.uleb128 .L1841-.LFB10471
	.uleb128 0
	.uleb128 .LEHB137-.LFB10471
	.uleb128 .LEHE137-.LEHB137
	.uleb128 .L1842-.LFB10471
	.uleb128 0
	.uleb128 .LEHB138-.LFB10471
	.uleb128 .LEHE138-.LEHB138
	.uleb128 .L1843-.LFB10471
	.uleb128 0
	.uleb128 .LEHB139-.LFB10471
	.uleb128 .LEHE139-.LEHB139
	.uleb128 .L1840-.LFB10471
	.uleb128 0
	.uleb128 .LEHB140-.LFB10471
	.uleb128 .LEHE140-.LEHB140
	.uleb128 .L1844-.LFB10471
	.uleb128 0x1
	.uleb128 .LEHB141-.LFB10471
	.uleb128 .LEHE141-.LEHB141
	.uleb128 .L1827-.LFB10471
	.uleb128 0
	.uleb128 .LEHB142-.LFB10471
	.uleb128 .LEHE142-.LEHB142
	.uleb128 .L1845-.LFB10471
	.uleb128 0
	.uleb128 .LEHB143-.LFB10471
	.uleb128 .LEHE143-.LEHB143
	.uleb128 .L1846-.LFB10471
	.uleb128 0
	.uleb128 .LEHB144-.LFB10471
	.uleb128 .LEHE144-.LEHB144
	.uleb128 .L1828-.LFB10471
	.uleb128 0
	.uleb128 .LEHB145-.LFB10471
	.uleb128 .LEHE145-.LEHB145
	.uleb128 .L1847-.LFB10471
	.uleb128 0
	.uleb128 .LEHB146-.LFB10471
	.uleb128 .LEHE146-.LEHB146
	.uleb128 .L1829-.LFB10471
	.uleb128 0
	.uleb128 .LEHB147-.LFB10471
	.uleb128 .LEHE147-.LEHB147
	.uleb128 .L1816-.LFB10471
	.uleb128 0
	.uleb128 .LEHB148-.LFB10471
	.uleb128 .LEHE148-.LEHB148
	.uleb128 .L1832-.LFB10471
	.uleb128 0
	.uleb128 .LEHB149-.LFB10471
	.uleb128 .LEHE149-.LEHB149
	.uleb128 .L1833-.LFB10471
	.uleb128 0
	.uleb128 .LEHB150-.LFB10471
	.uleb128 .LEHE150-.LEHB150
	.uleb128 .L1847-.LFB10471
	.uleb128 0
	.uleb128 .LEHB151-.LFB10471
	.uleb128 .LEHE151-.LEHB151
	.uleb128 .L1836-.LFB10471
	.uleb128 0
	.uleb128 .LEHB152-.LFB10471
	.uleb128 .LEHE152-.LEHB152
	.uleb128 .L1839-.LFB10471
	.uleb128 0
	.uleb128 .LEHB153-.LFB10471
	.uleb128 .LEHE153-.LEHB153
	.uleb128 .L1847-.LFB10471
	.uleb128 0
	.uleb128 .LEHB154-.LFB10471
	.uleb128 .LEHE154-.LEHB154
	.uleb128 .L1836-.LFB10471
	.uleb128 0
	.uleb128 .LEHB155-.LFB10471
	.uleb128 .LEHE155-.LEHB155
	.uleb128 .L1839-.LFB10471
	.uleb128 0
	.uleb128 .LEHB156-.LFB10471
	.uleb128 .LEHE156-.LEHB156
	.uleb128 .L1820-.LFB10471
	.uleb128 0
	.uleb128 .LEHB157-.LFB10471
	.uleb128 .LEHE157-.LEHB157
	.uleb128 .L1827-.LFB10471
	.uleb128 0
	.uleb128 .LEHB158-.LFB10471
	.uleb128 .LEHE158-.LEHB158
	.uleb128 .L1843-.LFB10471
	.uleb128 0
	.uleb128 .LEHB159-.LFB10471
	.uleb128 .LEHE159-.LEHB159
	.uleb128 .L1816-.LFB10471
	.uleb128 0
	.uleb128 .LEHB160-.LFB10471
	.uleb128 .LEHE160-.LEHB160
	.uleb128 .L1820-.LFB10471
	.uleb128 0
	.uleb128 .LEHB161-.LFB10471
	.uleb128 .LEHE161-.LEHB161
	.uleb128 0
	.uleb128 0
.LLSDACSE10471:
	.byte	0x1
	.byte	0
	.align	2
	.4byte	0

.LLSDATT10471:
	.text
	.size	_Z20write_simd_benchmarkPfS_Pimmmmm, .-_Z20write_simd_benchmarkPfS_Pimmmmm
	.section	.rodata.str1.8
	.align	3
.LC64:
	.string	"/anndata/"
	.align	3
.LC65:
	.string	"DEEP100K.query.fbin"
	.align	3
.LC66:
	.string	"DEEP100K.gt.query.100k.top100.bin"
	.align	3
.LC67:
	.string	"DEEP100K.base.100k.fbin"
	.align	3
.LC68:
	.string	"average recall: "
	.align	3
.LC69:
	.string	"average latency (us): "
	.section	.text.startup,"ax",@progbits
	.align	2
	.p2align 4,,11
	.global	main
	.type	main, %function
main:
.LFB10505:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA10505
	stp	x29, x30, [sp, -320]!
	.cfi_def_cfa_offset 320
	.cfi_offset 29, -320
	.cfi_offset 30, -312
	adrp	x2, .LC64
	add	x2, x2, :lo12:.LC64
	add	x3, sp, 256
	mov	x29, sp
	mov	x5, 9
	ldr	x4, [x2]
	stp	x19, x20, [sp, 16]
	ldrb	w2, [x2, 8]
	stp	x21, x22, [sp, 32]
	adrp	x1, .LC65
	add	x0, sp, 240
	stp	x23, x24, [sp, 48]
	add	x8, sp, 272
	add	x1, x1, :lo12:.LC65
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	stp	d8, d9, [sp, 96]
	.cfi_offset 19, -304
	.cfi_offset 20, -296
	.cfi_offset 21, -288
	.cfi_offset 22, -280
	.cfi_offset 23, -272
	.cfi_offset 24, -264
	.cfi_offset 25, -256
	.cfi_offset 26, -248
	.cfi_offset 27, -240
	.cfi_offset 28, -232
	.cfi_offset 72, -224
	.cfi_offset 73, -216
	str	x4, [sp, 256]
	strb	wzr, [sp, 265]
	strb	w2, [x3, 8]
	stp	xzr, xzr, [sp, 168]
	stp	xzr, xzr, [sp, 184]
	stp	x3, x5, [sp, 240]
.LEHB162:
	bl	_ZStplIcSt11char_traitsIcESaIcEENSt7__cxx1112basic_stringIT_T0_T1_EERKS8_PKS5_
.LEHE162:
	add	x2, sp, 192
	add	x1, sp, 168
	add	x0, sp, 272
.LEHB163:
	bl	_Z8LoadDataIfEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_
.LEHE163:
	mov	x2, x0
	add	x1, sp, 288
	ldr	x0, [sp, 272]
	str	x2, [sp, 136]
	cmp	x0, x1
	beq	.L1931
	bl	_ZdlPv
.L1931:
	adrp	x1, .LC66
	add	x8, sp, 272
	add	x1, x1, :lo12:.LC66
	add	x0, sp, 240
.LEHB164:
	bl	_ZStplIcSt11char_traitsIcESaIcEENSt7__cxx1112basic_stringIT_T0_T1_EERKS8_PKS5_
.LEHE164:
	add	x1, sp, 168
	add	x2, sp, 184
	add	x0, sp, 272
.LEHB165:
	bl	_Z8LoadDataIiEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_
.LEHE165:
	mov	x24, x0
	add	x1, sp, 288
	ldr	x0, [sp, 272]
	cmp	x0, x1
	beq	.L1932
	bl	_ZdlPv
.L1932:
	adrp	x1, .LC67
	add	x8, sp, 272
	add	x1, x1, :lo12:.LC67
	add	x0, sp, 240
.LEHB166:
	bl	_ZStplIcSt11char_traitsIcESaIcEENSt7__cxx1112basic_stringIT_T0_T1_EERKS8_PKS5_
.LEHE166:
	add	x2, sp, 192
	add	x1, sp, 176
	add	x0, sp, 272
.LEHB167:
	bl	_Z8LoadDataIfEPT_NSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEERmS8_
.LEHE167:
	mov	x2, x0
	add	x1, sp, 288
	ldr	x0, [sp, 272]
	str	x2, [sp, 144]
	cmp	x0, x1
	beq	.L1933
	bl	_ZdlPv
.L1933:
	mov	x1, 2000
	mov	x0, 64000
	str	x1, [sp, 168]
.LEHB168:
	bl	_Znwm
.LEHE168:
	mov	x1, 64000
	add	x1, x0, x1
	str	x0, [sp, 152]
.L1935:
	cmp	x1, x0
	beq	.L1934
	str	wzr, [x0]
	stp	xzr, xzr, [x0, 8]
	add	x0, x0, 32
	str	xzr, [x0, -8]
	b	.L1935
.L1934:
	ldr	x0, [sp, 168]
	cbz	x0, .L1938
	ldr	x0, [sp, 152]
	mov	x23, 0
	stp	x0, x0, [sp, 120]
	.p2align 3,,7
.L1986:
	add	x0, sp, 208
	mov	x1, 0
	bl	gettimeofday
	ldr	x19, [sp, 192]
	stp	xzr, xzr, [sp, 272]
	ldr	x0, [sp, 136]
	lsl	x26, x19, 2
	ldr	x25, [sp, 176]
	str	xzr, [sp, 288]
	madd	x21, x26, x23, x0
	cbz	x25, .L2002
	ldr	x20, [sp, 144]
	mov	x22, 0
	fmov	s8, 1.0e+0
	.p2align 3,,7
.L1959:
	movi	v0.4s, 0
	cmp	x19, 3
	bls	.L2003
	mov	x3, x21
	mov	x2, x20
	mov	x1, 4
	.p2align 3,,7
.L1942:
	ldr	q2, [x2], 16
	mov	x0, x1
	ldr	q1, [x3], 16
	add	x1, x1, 4
	fmla	v0.4s, v2.4s, v1.4s
	cmp	x19, x1
	bcs	.L1942
.L1941:
	faddp	v0.4s, v0.4s, v0.4s
	faddp	v0.4s, v0.4s, v0.4s
	cmp	x19, x0
	bls	.L1943
	.p2align 3,,7
.L1944:
	ldr	s2, [x20, x0, lsl 2]
	ldr	s1, [x21, x0, lsl 2]
	add	x0, x0, 1
	fmadd	s0, s2, s1, s0
	cmp	x19, x0
	bne	.L1944
.L1943:
	ldp	x0, x1, [sp, 272]
	fsub	s0, s8, s0
	sub	x2, x1, x0
	cmp	x2, 72
	bls	.L2061
	ldr	s1, [x0]
	fcmpe	s0, s1
	bmi	.L2022
.L1948:
	add	x22, x22, 1
	add	x20, x20, x26
	cmp	x25, x22
	bne	.L1959
	ldp	x19, x20, [sp, 272]
.L1940:
	mov	x1, 0
	add	x0, sp, 224
	bl	gettimeofday
	ldp	x1, x3, [sp, 224]
	mov	x4, 16960
	ldr	x2, [sp, 208]
	movk	x4, 0xf, lsl 16
	add	x0, sp, 280
	mov	x21, 0
	str	wzr, [sp, 280]
	msub	x2, x2, x4, x3
	stp	xzr, x0, [sp, 288]
	madd	x1, x1, x4, x2
	ldr	x3, [sp, 216]
	stp	x0, xzr, [sp, 304]
	sub	x22, x1, x3
	.p2align 3,,7
.L1960:
	ldr	x2, [sp, 184]
	add	x1, sp, 200
	add	x0, sp, 272
	madd	x2, x23, x2, x21
	ldr	w2, [x24, x2, lsl 2]
	str	w2, [sp, 200]
.LEHB169:
	bl	_ZNSt8_Rb_treeIjjSt9_IdentityIjESt4lessIjESaIjEE16_M_insert_uniqueIjEESt4pairISt17_Rb_tree_iteratorIjEbEOT_
.LEHE169:
	add	x21, x21, 1
	cmp	x21, 10
	bne	.L1960
	add	x11, sp, 280
	mov	x12, 0
	ldr	x21, [sp, 288]
	cmp	x19, x20
	beq	.L2062
	.p2align 3,,7
.L1964:
	ldr	w4, [x19, 4]
	cbz	x21, .L1967
	mov	x0, x21
	mov	x5, x11
	.p2align 3,,7
.L1968:
	ldr	w1, [x0, 32]
	ldp	x3, x2, [x0, 16]
	cmp	w4, w1
	bls	.L2009
	mov	x0, x2
	cbnz	x0, .L1968
.L1969:
	cmp	x5, x11
	beq	.L1967
	ldr	w0, [x5, 32]
	cmp	w4, w0
	cinc	x12, x12, cs
.L1967:
	sub	x0, x20, x19
	sub	x20, x20, #8
	cmp	x0, 8
	bgt	.L2063
.L1972:
	cmp	x20, x19
	bne	.L1964
	ucvtf	s0, x12
	fmov	s1, 1.0e+1
	ldr	x0, [sp, 120]
	fdiv	s0, s0, s1
	stp	xzr, xzr, [x0]
	str	x22, [x0, 8]
	stp	xzr, xzr, [x0, 16]
	str	s0, [x0]
	cbz	x21, .L1981
	.p2align 3,,7
.L1984:
	ldr	x0, [x21, 24]
	bl	_ZNSt8_Rb_treeIjjSt9_IdentityIjESt4lessIjESaIjEE8_M_eraseEPSt13_Rb_tree_nodeIjE.isra.0
	mov	x0, x21
	ldr	x21, [x21, 16]
	bl	_ZdlPv
	cbnz	x21, .L1984
.L1983:
	cbnz	x19, .L1981
.L1982:
	ldr	x1, [sp, 120]
	add	x23, x23, 1
	ldr	x0, [sp, 168]
	add	x1, x1, 32
	str	x1, [sp, 120]
	cmp	x0, x23
	bhi	.L1986
	cbz	x0, .L1938
	movi	v8.2s, #0
	ldr	x1, [sp, 152]
	fmov	s9, s8
	add	x0, x1, x0, lsl 5
	.p2align 3,,7
.L1987:
	ldr	x2, [sp, 128]
	add	x2, x2, 32
	ldr	x1, [x2, -24]
	ldr	s1, [x2, -32]
	scvtf	s0, x1
	str	x2, [sp, 128]
	fadd	s9, s9, s1
	fadd	s8, s8, s0
	cmp	x0, x2
	bne	.L1987
.L1937:
	adrp	x20, _ZSt4cout
	add	x20, x20, :lo12:_ZSt4cout
	adrp	x1, .LC68
	mov	x0, x20
	add	x1, x1, :lo12:.LC68
.LEHB170:
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	ldr	x1, [sp, 168]
	ucvtf	s0, x1
	fdiv	s0, s9, s0
	fcvt	d0, s0
	bl	_ZNSo9_M_insertIdEERSoT_
	adrp	x19, .LC10
	add	x19, x19, :lo12:.LC10
	mov	x1, x19
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	adrp	x1, .LC69
	mov	x0, x20
	add	x1, x1, :lo12:.LC69
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	ldr	x1, [sp, 168]
	ucvtf	s0, x1
	fdiv	s0, s8, s0
	fcvt	d0, s0
	bl	_ZNSo9_M_insertIdEERSoT_
	mov	x1, x19
	bl	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
	ldp	x1, x0, [sp, 136]
	mov	x2, x24
	ldp	x5, x3, [sp, 168]
	mov	x7, 10
	ldp	x6, x4, [sp, 184]
	bl	_Z20write_simd_benchmarkPfS_Pimmmmm
.LEHE170:
	ldr	x0, [sp, 152]
	bl	_ZdlPv
	ldr	x0, [sp, 240]
	add	x1, sp, 256
	cmp	x0, x1
	beq	.L2031
	bl	_ZdlPv
.L2031:
	mov	w0, 0
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	d8, d9, [sp, 96]
	ldp	x29, x30, [sp], 320
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_restore 72
	.cfi_restore 73
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L2009:
	.cfi_restore_state
	mov	x5, x0
	mov	x0, x3
	cbnz	x0, .L1968
	b	.L1969
	.p2align 2,,3
.L2063:
	sub	x1, x20, x19
	ldr	w0, [x20]
	ldr	s0, [x19]
	asr	x8, x1, 3
	ldr	w2, [x20, 4]
	sub	x6, x8, #1
	bfi	x27, x0, 0, 32
	str	s0, [x20]
	add	x6, x6, x6, lsr 63
	str	w4, [x20, 4]
	bfi	x27, x2, 32, 32
	asr	x6, x6, 1
	cmp	x1, 16
	ble	.L2010
	mov	x0, 0
	b	.L1977
	.p2align 2,,3
.L2012:
	mov	w2, w3
.L1976:
	lsl	x0, x0, 3
	add	x3, x19, x0
	str	s0, [x19, x0]
	str	w2, [x3, 4]
	cmp	x1, x6
	bge	.L1973
.L2013:
	mov	x0, x1
.L1977:
	add	x2, x0, 1
	lsl	x4, x2, 1
	lsl	x2, x2, 4
	sub	x1, x4, #1
	add	x7, x19, x2
	lsl	x3, x1, 3
	ldr	s1, [x19, x2]
	add	x5, x19, x3
	ldr	s0, [x19, x3]
	fcmpe	s1, s0
	bmi	.L2024
	ldr	w2, [x7, 4]
	bgt	.L2011
	ldr	w3, [x5, 4]
	cmp	w2, w3
	bcc	.L2012
.L2011:
	fmov	s0, s1
	lsl	x0, x0, 3
	add	x3, x19, x0
	mov	x1, x4
	str	s0, [x19, x0]
	str	w2, [x3, 4]
	cmp	x1, x6
	blt	.L2013
.L1973:
	tbnz	x8, 0, .L1978
	sub	x8, x8, #2
	add	x8, x8, x8, lsr 63
	cmp	x1, x8, asr 1
	bne	.L1978
	lsl	x2, x1, 1
	lsl	x0, x1, 3
	add	x1, x2, 1
	add	x3, x19, x0
	lsl	x2, x1, 3
	add	x4, x19, x2
	ldr	s0, [x19, x2]
	ldr	w2, [x4, 4]
	str	s0, [x19, x0]
	str	w2, [x3, 4]
	.p2align 3,,7
.L1978:
	mov	x3, x27
	mov	x0, x19
	mov	x2, 0
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldr	x21, [sp, 288]
	b	.L1972
	.p2align 2,,3
.L2024:
	ldr	w2, [x5, 4]
	b	.L1976
	.p2align 2,,3
.L2061:
	ldr	x2, [sp, 288]
	str	s0, [sp, 200]
	str	w22, [sp, 204]
	cmp	x1, x2
	beq	.L1946
	ldr	x2, [sp, 200]
	str	x2, [x1], 8
	str	x1, [sp, 280]
.L1947:
	ldr	x3, [x1, -8]
	sub	x2, x1, x0
	asr	x1, x2, 3
	mov	x2, 0
	sub	x1, x1, #1
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	b	.L1948
	.p2align 2,,3
.L2022:
	ldr	x2, [sp, 288]
	str	s0, [sp, 224]
	str	w22, [sp, 228]
	cmp	x1, x2
	beq	.L1950
	ldr	x2, [sp, 224]
	str	x2, [x1], 8
	str	x1, [sp, 280]
.L1951:
	ldr	x3, [x1, -8]
	sub	x2, x1, x0
	asr	x1, x2, 3
	mov	x2, 0
	sub	x1, x1, #1
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldp	x0, x1, [sp, 272]
	sub	x2, x1, x0
	cmp	x2, 8
	bgt	.L2064
.L1952:
	sub	x1, x1, #8
	str	x1, [sp, 280]
	b	.L1948
	.p2align 2,,3
.L2003:
	mov	x0, 0
	b	.L1941
.L2064:
	sub	x3, x1, #8
	ldr	w4, [x1, -8]
	sub	x3, x3, x0
	ldr	s0, [x0]
	ldr	w5, [x1, -4]
	asr	x9, x3, 3
	ldr	w6, [x0, 4]
	sub	x2, x9, #1
	bfi	x28, x4, 0, 32
	str	s0, [x1, -8]
	add	x2, x2, x2, lsr 63
	str	w6, [x1, -4]
	bfi	x28, x5, 32, 32
	asr	x6, x2, 1
	cmp	x3, 16
	ble	.L2004
	mov	x2, 0
	b	.L1957
.L2006:
	mov	w3, w4
.L1956:
	lsl	x2, x2, 3
	add	x4, x0, x2
	str	s0, [x0, x2]
	str	w3, [x4, 4]
	cmp	x6, x1
	ble	.L1953
.L2007:
	mov	x2, x1
.L1957:
	add	x3, x2, 1
	lsl	x5, x3, 1
	lsl	x3, x3, 4
	sub	x1, x5, #1
	add	x8, x0, x3
	lsl	x4, x1, 3
	ldr	s1, [x0, x3]
	add	x7, x0, x4
	ldr	s0, [x0, x4]
	fcmpe	s1, s0
	bmi	.L2023
	ldr	w3, [x8, 4]
	bgt	.L2005
	ldr	w4, [x7, 4]
	cmp	w4, w3
	bhi	.L2006
.L2005:
	fmov	s0, s1
	lsl	x2, x2, 3
	add	x4, x0, x2
	mov	x1, x5
	str	s0, [x0, x2]
	str	w3, [x4, 4]
	cmp	x6, x1
	bgt	.L2007
.L1953:
	tbnz	x9, 0, .L1958
	sub	x9, x9, #2
	add	x9, x9, x9, lsr 63
	cmp	x1, x9, asr 1
	bne	.L1958
	lsl	x3, x1, 1
	lsl	x2, x1, 3
	add	x1, x3, 1
	add	x4, x0, x2
	lsl	x3, x1, 3
	add	x5, x0, x3
	ldr	s0, [x0, x3]
	ldr	w3, [x5, 4]
	str	s0, [x0, x2]
	str	w3, [x4, 4]
.L1958:
	mov	x3, x28
	mov	x2, 0
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldr	x1, [sp, 280]
	b	.L1952
	.p2align 2,,3
.L2023:
	ldr	w3, [x7, 4]
	b	.L1956
.L1981:
	mov	x0, x19
	bl	_ZdlPv
	b	.L1982
.L1946:
	add	x2, sp, 200
	add	x0, sp, 272
.LEHB171:
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	ldp	x0, x1, [sp, 272]
	b	.L1947
.L1950:
	add	x2, sp, 224
	add	x0, sp, 272
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE171:
	ldp	x0, x1, [sp, 272]
	b	.L1951
.L2010:
	mov	x1, 0
	b	.L1973
.L2002:
	mov	x20, 0
	mov	x19, 0
	b	.L1940
.L2062:
	ldr	x0, [sp, 120]
	stp	xzr, xzr, [x0]
	str	x22, [x0, 8]
	stp	xzr, xzr, [x0, 16]
	cbnz	x21, .L1984
	b	.L1983
.L2004:
	mov	x1, 0
	b	.L1953
.L1938:
	movi	v8.2s, #0
	fmov	s9, s8
	b	.L1937
.L2014:
	mov	x19, x0
.L1991:
	ldr	x0, [sp, 240]
	add	x1, sp, 256
	cmp	x0, x1
	beq	.L2000
	bl	_ZdlPv
.L2000:
	mov	x0, x19
.LEHB172:
	bl	_Unwind_Resume
.LEHE172:
.L2021:
	mov	x19, x0
	b	.L1991
.L2019:
	mov	x20, x0
	ldr	x0, [sp, 288]
	bl	_ZNSt8_Rb_treeIjjSt9_IdentityIjESt4lessIjESaIjEE8_M_eraseEPSt13_Rb_tree_nodeIjE.isra.0
	cbz	x19, .L1997
	mov	x0, x19
	bl	_ZdlPv
.L1997:
	mov	x19, x20
.L1963:
	ldr	x0, [sp, 152]
	bl	_ZdlPv
	b	.L1991
.L2020:
	ldr	x1, [sp, 272]
	mov	x19, x0
	cbz	x1, .L1963
	mov	x0, x1
	bl	_ZdlPv
	b	.L1963
.L2018:
	mov	x19, x0
	b	.L1963
.L2017:
.L2059:
	ldr	x1, [sp, 272]
	add	x2, sp, 288
	mov	x19, x0
	cmp	x1, x2
	beq	.L1991
	mov	x0, x1
	bl	_ZdlPv
	b	.L1991
.L2016:
	b	.L2059
.L2015:
	b	.L2059
	.cfi_endproc
.LFE10505:
	.section	.gcc_except_table
.LLSDA10505:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE10505-.LLSDACSB10505
.LLSDACSB10505:
	.uleb128 .LEHB162-.LFB10505
	.uleb128 .LEHE162-.LEHB162
	.uleb128 .L2014-.LFB10505
	.uleb128 0
	.uleb128 .LEHB163-.LFB10505
	.uleb128 .LEHE163-.LEHB163
	.uleb128 .L2015-.LFB10505
	.uleb128 0
	.uleb128 .LEHB164-.LFB10505
	.uleb128 .LEHE164-.LEHB164
	.uleb128 .L2014-.LFB10505
	.uleb128 0
	.uleb128 .LEHB165-.LFB10505
	.uleb128 .LEHE165-.LEHB165
	.uleb128 .L2016-.LFB10505
	.uleb128 0
	.uleb128 .LEHB166-.LFB10505
	.uleb128 .LEHE166-.LEHB166
	.uleb128 .L2014-.LFB10505
	.uleb128 0
	.uleb128 .LEHB167-.LFB10505
	.uleb128 .LEHE167-.LEHB167
	.uleb128 .L2017-.LFB10505
	.uleb128 0
	.uleb128 .LEHB168-.LFB10505
	.uleb128 .LEHE168-.LEHB168
	.uleb128 .L2021-.LFB10505
	.uleb128 0
	.uleb128 .LEHB169-.LFB10505
	.uleb128 .LEHE169-.LEHB169
	.uleb128 .L2019-.LFB10505
	.uleb128 0
	.uleb128 .LEHB170-.LFB10505
	.uleb128 .LEHE170-.LEHB170
	.uleb128 .L2018-.LFB10505
	.uleb128 0
	.uleb128 .LEHB171-.LFB10505
	.uleb128 .LEHE171-.LEHB171
	.uleb128 .L2020-.LFB10505
	.uleb128 0
	.uleb128 .LEHB172-.LFB10505
	.uleb128 .LEHE172-.LEHB172
	.uleb128 0
	.uleb128 0
.LLSDACSE10505:
	.section	.text.startup
	.size	main, .-main
	.section	.text._ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERKj,"axG",@progbits,_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERKj,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERKj
	.type	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERKj, %function
_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERKj:
.LFB12155:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	ldr	w8, [x2]
	ldr	x1, [x0, 8]
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	mov	x19, x0
	uxtw	x0, w8
	udiv	x3, x0, x1
	ldr	x9, [x19]
	msub	x3, x3, x1, x0
	ldr	x6, [x9, x3, lsl 3]
	cbz	x6, .L2076
	ldr	x2, [x6]
	mov	x5, x6
	ldr	w0, [x2, 8]
.L2068:
	cmp	w8, w0
	beq	.L2067
	ldr	x0, [x2]
	mov	x5, x2
	mov	x2, x0
	cbz	x0, .L2076
	ldr	w0, [x0, 8]
	uxtw	x7, w0
	udiv	x4, x7, x1
	msub	x4, x4, x1, x7
	cmp	x3, x4
	beq	.L2068
.L2076:
	mov	x0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L2067:
	.cfi_restore_state
	ldr	x0, [x5]
	ldr	x2, [x0]
	cmp	x6, x5
	beq	.L2083
	cbz	x2, .L2070
	ldr	w6, [x2, 8]
	udiv	x4, x6, x1
	msub	x1, x4, x1, x6
	cmp	x3, x1
	beq	.L2070
	str	x5, [x9, x1, lsl 3]
	ldr	x2, [x0]
.L2070:
	str	x2, [x5]
	bl	_ZdlPv
	ldr	x1, [x19, 24]
	mov	x0, 1
	sub	x1, x1, #1
	str	x1, [x19, 24]
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L2083:
	.cfi_restore_state
	cbz	x2, .L2077
	ldr	w6, [x2, 8]
	udiv	x4, x6, x1
	msub	x1, x4, x1, x6
	cmp	x3, x1
	beq	.L2070
	str	x5, [x9, x1, lsl 3]
	ldr	x1, [x9, x3, lsl 3]
.L2069:
	add	x4, x19, 16
	cmp	x1, x4
	beq	.L2084
.L2071:
	str	xzr, [x9, x3, lsl 3]
	ldr	x2, [x0]
	b	.L2070
	.p2align 2,,3
.L2077:
	mov	x1, x5
	b	.L2069
	.p2align 2,,3
.L2084:
	str	x2, [x19, 16]
	b	.L2071
	.cfi_endproc
.LFE12155:
	.size	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERKj, .-_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERKj
	.section	.rodata._ZN7hnswlib15HierarchicalNSWIfE21unmarkDeletedInternalEj.str1.8,"aMS",@progbits,1
	.align	3
.LC70:
	.string	"void hnswlib::HierarchicalNSW<dist_t>::unmarkDeletedInternal(hnswlib::tableint) [with dist_t = float; hnswlib::tableint = unsigned int]"
	.align	3
.LC71:
	.string	"hnswlib/hnswlib/hnswalg.h"
	.align	3
.LC72:
	.string	"internalId < cur_element_count"
	.align	3
.LC73:
	.string	"The requested to undelete element is not deleted"
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE21unmarkDeletedInternalEj,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE21unmarkDeletedInternalEj,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib15HierarchicalNSWIfE21unmarkDeletedInternalEj
	.type	_ZN7hnswlib15HierarchicalNSWIfE21unmarkDeletedInternalEj, %function
_ZN7hnswlib15HierarchicalNSWIfE21unmarkDeletedInternalEj:
.LFB11505:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA11505
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	uxtw	x2, w1
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -48
	mov	x19, x0
	str	w1, [sp, 44]
	add	x0, x0, 16
	ldar	x0, [x0]
	cmp	x2, x0
	bcs	.L2106
	ldr	w1, [sp, 44]
	ldr	x3, [x19, 24]
	ldr	x2, [x19, 240]
	ldr	x0, [x19, 256]
	madd	x1, x1, x3, x2
	add	x0, x0, x1
	ldrb	w1, [x0, 2]
	tbz	x1, 0, .L2087
	and	w1, w1, -2
	strb	w1, [x0, 2]
	add	x0, x19, 40
.L2109:
	ldaxr	x1, [x0]
	sub	x1, x1, #1
	stlxr	w2, x1, [x0]
	cbnz	w2, .L2109
	ldrb	w0, [x19, 456]
	cbnz	w0, .L2107
.L2085:
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 64
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L2107:
	.cfi_restore_state
	adrp	x1, .LC36
	add	x0, x19, 464
	str	x0, [sp, 48]
	ldr	x1, [x1, #:lo12:.LC36]
	strb	wzr, [sp, 56]
	cbz	x1, .L2089
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L2108
.L2089:
	mov	w3, 1
	add	x0, x19, 512
	add	x2, sp, 44
	mov	w1, 0
	strb	w3, [sp, 56]
	bl	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERKj
	ldrb	w0, [sp, 56]
	cbz	w0, .L2085
	add	x0, sp, 48
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 64
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
.L2106:
	.cfi_restore_state
	adrp	x3, .LC70
	adrp	x1, .LC71
	adrp	x0, .LC72
	add	x3, x3, :lo12:.LC70
	add	x1, x1, :lo12:.LC71
	add	x0, x0, :lo12:.LC72
	mov	w2, 916
	bl	__assert_fail
.L2108:
.LEHB173:
	bl	_ZSt20__throw_system_errori
.LEHE173:
.L2087:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC73
	mov	x19, x0
	add	x1, x1, :lo12:.LC73
.LEHB174:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE174:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x19
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB175:
	bl	__cxa_throw
.L2092:
	mov	x1, x0
	mov	x0, x19
	mov	x19, x1
	bl	__cxa_free_exception
	mov	x0, x19
	bl	_Unwind_Resume
.LEHE175:
	.cfi_endproc
.LFE11505:
	.section	.gcc_except_table
.LLSDA11505:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE11505-.LLSDACSB11505
.LLSDACSB11505:
	.uleb128 .LEHB173-.LFB11505
	.uleb128 .LEHE173-.LEHB173
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB174-.LFB11505
	.uleb128 .LEHE174-.LEHB174
	.uleb128 .L2092-.LFB11505
	.uleb128 0
	.uleb128 .LEHB175-.LFB11505
	.uleb128 .LEHE175-.LEHB175
	.uleb128 0
	.uleb128 0
.LLSDACSE11505:
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE21unmarkDeletedInternalEj,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE21unmarkDeletedInternalEj,comdat
	.size	_ZN7hnswlib15HierarchicalNSWIfE21unmarkDeletedInternalEj, .-_ZN7hnswlib15HierarchicalNSWIfE21unmarkDeletedInternalEj
	.section	.text._ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERS1_,"axG",@progbits,_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERS1_,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERS1_
	.type	_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERS1_, %function
_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERS1_:
.LFB12156:
	.cfi_startproc
	ldr	x5, [x2]
	ldr	x2, [x0, 8]
	ldr	x8, [x0]
	udiv	x4, x5, x2
	msub	x4, x4, x2, x5
	ldr	x7, [x8, x4, lsl 3]
	cbz	x7, .L2119
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x6, x7
	mov	x29, sp
	ldr	x3, [x7]
	ldr	x1, [x3, 8]
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	mov	x19, x0
.L2113:
	cmp	x5, x1
	beq	.L2112
	ldr	x0, [x3]
	mov	x6, x3
	mov	x3, x0
	cbz	x0, .L2121
	ldr	x1, [x0, 8]
	udiv	x0, x1, x2
	msub	x0, x0, x2, x1
	cmp	x4, x0
	beq	.L2113
.L2121:
	mov	x0, 0
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L2112:
	.cfi_restore_state
	ldr	x0, [x6]
	ldr	x1, [x0]
	cmp	x7, x6
	beq	.L2131
	cbz	x1, .L2115
	ldr	x5, [x1, 8]
	udiv	x3, x5, x2
	msub	x2, x3, x2, x5
	cmp	x4, x2
	beq	.L2115
	str	x6, [x8, x2, lsl 3]
	ldr	x1, [x0]
.L2115:
	str	x1, [x6]
	bl	_ZdlPv
	ldr	x1, [x19, 24]
	mov	x0, 1
	sub	x1, x1, #1
	str	x1, [x19, 24]
	ldr	x19, [sp, 16]
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L2131:
	.cfi_restore_state
	cbz	x1, .L2122
	ldr	x5, [x1, 8]
	udiv	x3, x5, x2
	msub	x2, x3, x2, x5
	cmp	x4, x2
	beq	.L2115
	str	x6, [x8, x2, lsl 3]
	ldr	x2, [x8, x4, lsl 3]
.L2114:
	add	x3, x19, 16
	cmp	x2, x3
	beq	.L2132
.L2116:
	str	xzr, [x8, x4, lsl 3]
	ldr	x1, [x0]
	b	.L2115
	.p2align 2,,3
.L2122:
	mov	x2, x6
	b	.L2114
	.p2align 2,,3
.L2119:
	.cfi_def_cfa_offset 0
	.cfi_restore 19
	.cfi_restore 29
	.cfi_restore 30
	mov	x0, 0
	ret
	.p2align 2,,3
.L2132:
	.cfi_def_cfa_offset 32
	.cfi_offset 19, -16
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	str	x1, [x19, 16]
	b	.L2116
	.cfi_endproc
.LFE12156:
	.size	_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERS1_, .-_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERS1_
	.section	.text._ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_,"axG",@progbits,_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.type	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_, %function
_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_:
.LFB12328:
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	ldp	x24, x23, [x0]
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	mov	x21, x0
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	sub	x0, x23, x24
	stp	x27, x28, [sp, 80]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	.cfi_offset 27, -16
	.cfi_offset 28, -8
	mov	x27, x2
	asr	x0, x0, 3
	mov	x2, 1152921504606846975
	cmp	x0, x2
	beq	.L2151
	cmp	x0, 0
	mov	x19, x1
	sub	x26, x1, x24
	csinc	x1, x0, xzr, ne
	mov	x28, x3
	adds	x1, x1, x0
	bcs	.L2144
	cbnz	x1, .L2138
	mov	x25, 8
	mov	x22, 0
	mov	x20, 0
.L2143:
	ldr	s0, [x27]
	add	x0, x20, x26
	ldr	w1, [x28]
	str	s0, [x20, x26]
	str	w1, [x0, 4]
	cmp	x19, x24
	beq	.L2139
	mov	x4, x20
	mov	x3, x24
	.p2align 3,,7
.L2140:
	ldr	x5, [x3], 8
	str	x5, [x4], 8
	cmp	x3, x19
	bne	.L2140
	add	x26, x26, 8
	add	x25, x20, x26
.L2139:
	cmp	x19, x23
	beq	.L2141
	sub	x2, x23, x19
	mov	x0, x25
	mov	x1, x19
	add	x25, x25, x2
	bl	memcpy
.L2141:
	cbz	x24, .L2142
	mov	x0, x24
	bl	_ZdlPv
.L2142:
	ldp	x23, x24, [sp, 48]
	ldp	x27, x28, [sp, 80]
	stp	x20, x25, [x21]
	str	x22, [x21, 16]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L2144:
	.cfi_restore_state
	mov	x22, 9223372036854775800
.L2137:
	mov	x0, x22
	bl	_Znwm
	mov	x20, x0
	add	x22, x0, x22
	add	x25, x0, 8
	b	.L2143
.L2138:
	cmp	x1, x2
	csel	x1, x1, x2, ls
	lsl	x22, x1, 3
	b	.L2137
.L2151:
	adrp	x0, .LC42
	add	x0, x0, :lo12:.LC42
	bl	_ZSt20__throw_length_errorPKc
	.cfi_endproc
.LFE12328:
	.size	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_, .-_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.section	.text._ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE7emplaceIJfRjEEEvDpOT_,"axG",@progbits,_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE7emplaceIJfRjEEEvDpOT_,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE7emplaceIJfRjEEEvDpOT_
	.type	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE7emplaceIJfRjEEEvDpOT_, %function
_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE7emplaceIJfRjEEEvDpOT_:
.LFB11872:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	ldp	x5, x3, [x0, 8]
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	mov	x19, x0
	cmp	x5, x3
	beq	.L2153
	ldr	s1, [x1]
	add	x4, x5, 8
	ldr	w8, [x2]
	str	w8, [x5, 4]
	str	s1, [x5]
	str	x4, [x0, 8]
.L2154:
	ldr	x3, [x19]
	sub	x4, x4, x3
	asr	x6, x4, 3
	sub	x1, x6, #2
	sub	x6, x6, #1
	add	x1, x1, x1, lsr 63
	asr	x1, x1, 1
	cmp	x6, 0
	ble	.L2162
	.p2align 3,,7
.L2158:
	lsl	x2, x1, 3
	sub	x0, x1, #1
	lsl	x4, x6, 3
	add	x7, x3, x2
	add	x0, x0, x0, lsr 63
	add	x5, x3, x4
	ldr	s0, [x3, x2]
	mov	x6, x1
	asr	x0, x0, 1
	fcmpe	s0, s1
	bmi	.L2160
.L2156:
	ldr	x19, [sp, 16]
	str	w8, [x5, 4]
	str	s1, [x5]
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L2160:
	.cfi_restore_state
	ldr	w2, [x7, 4]
	str	s0, [x3, x4]
	str	w2, [x5, 4]
	cmp	x1, 0
	ble	.L2163
	mov	x1, x0
	b	.L2158
	.p2align 2,,3
.L2163:
	mov	x5, x7
	ldr	x19, [sp, 16]
	str	w8, [x5, 4]
	str	s1, [x5]
	ldp	x29, x30, [sp], 32
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L2153:
	.cfi_restore_state
	mov	x3, x2
	mov	x2, x1
	mov	x1, x5
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	ldr	x4, [x19, 8]
	ldr	w8, [x4, -4]
	ldr	s1, [x4, -8]
	b	.L2154
.L2162:
	sub	x4, x4, #8
	add	x5, x3, x4
	b	.L2156
	.cfi_endproc
.LFE11872:
	.size	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE7emplaceIJfRjEEEvDpOT_, .-_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE7emplaceIJfRjEEEvDpOT_
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE24getNeighborsByHeuristic2ERSt14priority_queueISt4pairIfjESt6vectorIS4_SaIS4_EENS1_14CompareByFirstEEm,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE24getNeighborsByHeuristic2ERSt14priority_queueISt4pairIfjESt6vectorIS4_SaIS4_EENS1_14CompareByFirstEEm,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib15HierarchicalNSWIfE24getNeighborsByHeuristic2ERSt14priority_queueISt4pairIfjESt6vectorIS4_SaIS4_EENS1_14CompareByFirstEEm
	.type	_ZN7hnswlib15HierarchicalNSWIfE24getNeighborsByHeuristic2ERSt14priority_queueISt4pairIfjESt6vectorIS4_SaIS4_EENS1_14CompareByFirstEEm, %function
_ZN7hnswlib15HierarchicalNSWIfE24getNeighborsByHeuristic2ERSt14priority_queueISt4pairIfjESt6vectorIS4_SaIS4_EENS1_14CompareByFirstEEm:
.LFB11921:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA11921
	stp	x29, x30, [sp, -176]!
	.cfi_def_cfa_offset 176
	.cfi_offset 29, -176
	.cfi_offset 30, -168
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -160
	.cfi_offset 20, -152
	mov	x19, x0
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -128
	.cfi_offset 24, -120
	ldp	x23, x0, [x1]
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -144
	.cfi_offset 22, -136
	mov	x22, x1
	sub	x1, x0, x23
	cmp	x2, x1, asr 3
	bhi	.L2164
	stp	x25, x26, [sp, 64]
	.cfi_offset 26, -104
	.cfi_offset 25, -112
	mov	x24, x2
	mov	x25, 0
	stp	x27, x28, [sp, 80]
	.cfi_offset 28, -88
	.cfi_offset 27, -96
	mov	x21, 0
	mov	x20, 0
	stp	xzr, xzr, [sp, 152]
	mov	x28, 1152921504606846975
	str	xzr, [sp, 168]
	cmp	x23, x0
	beq	.L2254
	str	d8, [sp, 96]
	.cfi_offset 72, -80
	b	.L2166
	.p2align 2,,3
.L2256:
	ldr	w0, [x23, 4]
	add	x21, x21, 8
	str	w0, [x21, -4]
	str	s8, [x21, -8]
.L2171:
	sub	x1, x21, x20
	mov	x2, 0
	ldr	x3, [x21, -8]
	asr	x1, x1, 3
	sub	x1, x1, #1
	mov	x0, x20
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	mov	x0, x22
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	ldp	x23, x0, [x22]
	cmp	x23, x0
	beq	.L2255
.L2166:
	ldr	s8, [x23]
	fneg	s8, s8
	cmp	x25, x21
	bne	.L2256
	sub	x27, x25, x20
	asr	x0, x27, 3
	cmp	x0, x28
	beq	.L2257
	cmp	x0, 0
	csinc	x1, x0, xzr, ne
	adds	x0, x0, x1
	bcs	.L2174
	cbnz	x0, .L2258
	mov	x2, 8
	mov	x25, 0
	mov	x4, 0
.L2176:
	add	x0, x4, x27
	ldr	w1, [x23, 4]
	str	s8, [x4, x27]
	str	w1, [x0, 4]
	cmp	x21, x20
	beq	.L2211
	mov	x2, x4
	mov	x1, x20
	.p2align 3,,7
.L2178:
	ldr	x3, [x1], 8
	str	x3, [x2], 8
	cmp	x1, x21
	bne	.L2178
	sub	x21, x21, x20
	add	x21, x21, 8
	add	x21, x4, x21
	cbz	x20, .L2179
.L2263:
	mov	x0, x20
	str	x4, [sp, 120]
	bl	_ZdlPv
	ldr	x4, [sp, 120]
.L2179:
	mov	x20, x4
	b	.L2171
	.p2align 2,,3
.L2255:
	ldr	x23, [sp, 160]
	cmp	x21, x20
	beq	.L2253
	.p2align 3,,7
.L2168:
	ldr	x25, [sp, 152]
	sub	x0, x23, x25
	cmp	x24, x0, asr 3
	bls	.L2169
	ldr	x0, [x20]
	str	x0, [sp, 144]
	sub	x0, x21, x20
	sub	x21, x21, #8
	ldr	s8, [sp, 144]
	cmp	x0, 8
	fneg	s8, s8
	bgt	.L2259
.L2182:
	cmp	x23, x25
	beq	.L2189
	.p2align 3,,7
.L2193:
	ldr	w0, [x25, 4]
	ldr	w1, [sp, 148]
	ldr	x5, [x19, 24]
	ldr	x4, [x19, 232]
	ldp	x6, x2, [x19, 304]
	ldr	x3, [x19, 256]
	madd	x1, x1, x5, x4
	madd	x0, x0, x5, x4
	add	x1, x3, x1
	add	x0, x3, x0
.LEHB176:
	blr	x6
	fcmpe	s8, s0
	bgt	.L2252
	add	x25, x25, 8
	cmp	x25, x23
	bne	.L2193
	ldr	x25, [sp, 160]
.L2189:
	ldr	x0, [sp, 168]
	cmp	x0, x25
	beq	.L2260
	mov	x23, x25
	ldr	x0, [sp, 144]
	str	x0, [x23], 8
	str	x23, [sp, 160]
.L2192:
	cmp	x20, x21
	bne	.L2168
.L2253:
	ldr	x25, [sp, 152]
.L2169:
	cmp	x23, x25
	beq	.L2194
	ldr	x1, [x22, 8]
	.p2align 3,,7
.L2201:
	ldr	x0, [x25]
	str	x0, [sp, 144]
	ldr	x0, [x22, 16]
	ldr	s1, [sp, 144]
	fneg	s1, s1
	str	s1, [sp, 140]
	cmp	x0, x1
	beq	.L2195
	ldr	w8, [sp, 148]
	add	x1, x1, 8
	str	s1, [x1, -8]
	str	w8, [x1, -4]
	str	x1, [x22, 8]
.L2196:
	ldr	x4, [x22]
	sub	x3, x1, x4
	asr	x0, x3, 3
	sub	x2, x0, #2
	sub	x0, x0, #1
	add	x2, x2, x2, lsr 63
	asr	x2, x2, 1
	cmp	x0, 0
	ble	.L2197
	.p2align 3,,7
.L2200:
	lsl	x3, x2, 3
	lsl	x0, x0, 3
	add	x6, x4, x3
	add	x5, x4, x0
	ldr	s0, [x4, x3]
	fcmpe	s0, s1
	bmi	.L2220
	add	x25, x25, 8
	str	s1, [x5]
	str	w8, [x5, 4]
	cmp	x23, x25
	bne	.L2201
.L2262:
	ldr	x25, [sp, 152]
.L2194:
	cbz	x25, .L2202
	mov	x0, x25
	bl	_ZdlPv
.L2202:
	cbnz	x20, .L2261
	ldp	x25, x26, [sp, 64]
	.cfi_restore 26
	.cfi_restore 25
	ldp	x27, x28, [sp, 80]
	.cfi_restore 28
	.cfi_restore 27
	ldr	d8, [sp, 96]
	.cfi_restore 72
.L2164:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 176
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
.L2260:
	.cfi_def_cfa_offset 176
	.cfi_offset 19, -160
	.cfi_offset 20, -152
	.cfi_offset 21, -144
	.cfi_offset 22, -136
	.cfi_offset 23, -128
	.cfi_offset 24, -120
	.cfi_offset 25, -112
	.cfi_offset 26, -104
	.cfi_offset 27, -96
	.cfi_offset 28, -88
	.cfi_offset 29, -176
	.cfi_offset 30, -168
	.cfi_offset 72, -80
	mov	x1, x25
	add	x2, sp, 144
	add	x0, sp, 152
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRKS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.p2align 3,,7
.L2252:
	ldr	x23, [sp, 160]
	b	.L2192
	.p2align 2,,3
.L2259:
	sub	x1, x21, x20
	ldr	w0, [x21]
	ldr	s0, [x20]
	asr	x8, x1, 3
	ldr	w2, [x21, 4]
	sub	x6, x8, #1
	ldr	w3, [x20, 4]
	bfi	x26, x0, 0, 32
	str	s0, [x21]
	add	x6, x6, x6, lsr 63
	str	w3, [x21, 4]
	bfi	x26, x2, 32, 32
	asr	x6, x6, 1
	cmp	x1, 16
	ble	.L2212
	mov	x0, 0
	b	.L2187
	.p2align 2,,3
.L2214:
	mov	w2, w3
.L2186:
	lsl	x0, x0, 3
	add	x3, x20, x0
	str	s0, [x20, x0]
	str	w2, [x3, 4]
	cmp	x1, x6
	bge	.L2183
.L2215:
	mov	x0, x1
.L2187:
	add	x2, x0, 1
	lsl	x4, x2, 1
	lsl	x2, x2, 4
	sub	x1, x4, #1
	add	x7, x20, x2
	lsl	x3, x1, 3
	ldr	s1, [x20, x2]
	add	x5, x20, x3
	ldr	s0, [x20, x3]
	fcmpe	s1, s0
	bmi	.L2218
	ldr	w2, [x7, 4]
	bgt	.L2213
	ldr	w3, [x5, 4]
	cmp	w3, w2
	bhi	.L2214
.L2213:
	fmov	s0, s1
	lsl	x0, x0, 3
	add	x3, x20, x0
	mov	x1, x4
	str	s0, [x20, x0]
	str	w2, [x3, 4]
	cmp	x1, x6
	blt	.L2215
.L2183:
	tbnz	x8, 0, .L2188
	sub	x8, x8, #2
	add	x8, x8, x8, lsr 63
	cmp	x1, x8, asr 1
	bne	.L2188
	lsl	x2, x1, 1
	lsl	x0, x1, 3
	add	x1, x2, 1
	add	x3, x20, x0
	lsl	x2, x1, 3
	add	x4, x20, x2
	ldr	s0, [x20, x2]
	ldr	w2, [x4, 4]
	str	s0, [x20, x0]
	str	w2, [x3, 4]
	.p2align 3,,7
.L2188:
	mov	x3, x26
	mov	x0, x20
	mov	x2, 0
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfjESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldp	x25, x23, [sp, 152]
	b	.L2182
	.p2align 2,,3
.L2218:
	ldr	w2, [x5, 4]
	b	.L2186
	.p2align 2,,3
.L2220:
	sub	x3, x2, #1
	ldr	w7, [x6, 4]
	str	s0, [x4, x0]
	mov	x0, x2
	add	x3, x3, x3, lsr 63
	str	w7, [x5, 4]
	asr	x2, x3, 1
	cmp	x0, 0
	bgt	.L2200
	mov	x5, x6
	add	x25, x25, 8
	str	s1, [x5]
	str	w8, [x5, 4]
	cmp	x23, x25
	bne	.L2201
	b	.L2262
	.p2align 2,,3
.L2195:
	add	x3, sp, 148
	add	x2, sp, 140
	mov	x0, x22
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	ldr	x1, [x22, 8]
	ldr	w8, [x1, -4]
	ldr	s1, [x1, -8]
	b	.L2196
.L2261:
	mov	x0, x20
	ldr	d8, [sp, 96]
	.cfi_remember_state
	.cfi_restore 72
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	.cfi_restore 26
	.cfi_restore 25
	ldp	x27, x28, [sp, 80]
	.cfi_restore 28
	.cfi_restore 27
	ldp	x29, x30, [sp], 176
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	b	_ZdlPv
.L2197:
	.cfi_restore_state
	sub	x3, x3, #8
	add	x25, x25, 8
	add	x5, x4, x3
	str	s1, [x5]
	str	w8, [x5, 4]
	cmp	x23, x25
	bne	.L2201
	b	.L2262
.L2212:
	mov	x1, 0
	b	.L2183
.L2211:
	mov	x21, x2
	cbnz	x20, .L2263
	b	.L2179
.L2254:
	.cfi_restore 72
	ldp	x25, x26, [sp, 64]
	.cfi_restore 26
	.cfi_restore 25
	ldp	x27, x28, [sp, 80]
	.cfi_restore 28
	.cfi_restore 27
	b	.L2164
.L2258:
	.cfi_offset 25, -112
	.cfi_offset 26, -104
	.cfi_offset 27, -96
	.cfi_offset 28, -88
	.cfi_offset 72, -80
	cmp	x0, x28
	csel	x0, x0, x28, ls
	lsl	x25, x0, 3
.L2175:
	mov	x0, x25
	bl	_Znwm
	mov	x4, x0
	add	x25, x0, x25
	add	x2, x0, 8
	b	.L2176
.L2257:
	adrp	x0, .LC42
	add	x0, x0, :lo12:.LC42
	bl	_ZSt20__throw_length_errorPKc
.LEHE176:
.L2174:
	mov	x25, 9223372036854775800
	b	.L2175
.L2217:
	ldr	x1, [sp, 152]
	mov	x19, x0
	cbz	x1, .L2204
	mov	x0, x1
	bl	_ZdlPv
.L2204:
	cbz	x20, .L2205
	mov	x0, x20
	bl	_ZdlPv
.L2205:
	mov	x0, x19
.LEHB177:
	bl	_Unwind_Resume
.LEHE177:
	.cfi_endproc
.LFE11921:
	.section	.gcc_except_table
.LLSDA11921:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE11921-.LLSDACSB11921
.LLSDACSB11921:
	.uleb128 .LEHB176-.LFB11921
	.uleb128 .LEHE176-.LEHB176
	.uleb128 .L2217-.LFB11921
	.uleb128 0
	.uleb128 .LEHB177-.LFB11921
	.uleb128 .LEHE177-.LEHB177
	.uleb128 0
	.uleb128 0
.LLSDACSE11921:
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE24getNeighborsByHeuristic2ERSt14priority_queueISt4pairIfjESt6vectorIS4_SaIS4_EENS1_14CompareByFirstEEm,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE24getNeighborsByHeuristic2ERSt14priority_queueISt4pairIfjESt6vectorIS4_SaIS4_EENS1_14CompareByFirstEEm,comdat
	.size	_ZN7hnswlib15HierarchicalNSWIfE24getNeighborsByHeuristic2ERSt14priority_queueISt4pairIfjESt6vectorIS4_SaIS4_EENS1_14CompareByFirstEEm, .-_ZN7hnswlib15HierarchicalNSWIfE24getNeighborsByHeuristic2ERSt14priority_queueISt4pairIfjESt6vectorIS4_SaIS4_EENS1_14CompareByFirstEEm
	.section	.text._ZNSt6vectorIjSaIjEE17_M_realloc_insertIJRKjEEEvN9__gnu_cxx17__normal_iteratorIPjS1_EEDpOT_,"axG",@progbits,_ZNSt6vectorIjSaIjEE17_M_realloc_insertIJRKjEEEvN9__gnu_cxx17__normal_iteratorIPjS1_EEDpOT_,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt6vectorIjSaIjEE17_M_realloc_insertIJRKjEEEvN9__gnu_cxx17__normal_iteratorIPjS1_EEDpOT_
	.type	_ZNSt6vectorIjSaIjEE17_M_realloc_insertIJRKjEEEvN9__gnu_cxx17__normal_iteratorIPjS1_EEDpOT_, %function
_ZNSt6vectorIjSaIjEE17_M_realloc_insertIJRKjEEEvN9__gnu_cxx17__normal_iteratorIPjS1_EEDpOT_:
.LFB12344:
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	ldp	x25, x21, [x0]
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	mov	x24, x1
	mov	x1, 2305843009213693951
	str	x27, [sp, 80]
	.cfi_offset 27, -16
	sub	x3, x21, x25
	asr	x3, x3, 2
	cmp	x3, x1
	beq	.L2279
	cmp	x3, 0
	mov	x20, x0
	csinc	x0, x3, xzr, ne
	mov	x27, x2
	sub	x26, x24, x25
	adds	x3, x3, x0
	bcs	.L2276
	cbnz	x3, .L2269
	mov	x19, 0
	mov	x23, 0
.L2275:
	ldr	w0, [x27]
	add	x22, x26, 4
	sub	x21, x21, x24
	add	x22, x23, x22
	str	w0, [x23, x26]
	add	x27, x22, x21
	cmp	x26, 0
	bgt	.L2280
	cmp	x21, 0
	bgt	.L2271
	cbnz	x25, .L2274
.L2272:
	ldp	x21, x22, [sp, 32]
	ldp	x25, x26, [sp, 64]
	stp	x23, x27, [x20]
	str	x19, [x20, 16]
	ldp	x19, x20, [sp, 16]
	ldp	x23, x24, [sp, 48]
	ldr	x27, [sp, 80]
	ldp	x29, x30, [sp], 96
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L2280:
	.cfi_restore_state
	mov	x2, x26
	mov	x1, x25
	mov	x0, x23
	bl	memmove
	cmp	x21, 0
	bgt	.L2271
.L2274:
	mov	x0, x25
	bl	_ZdlPv
	b	.L2272
	.p2align 2,,3
.L2271:
	mov	x2, x21
	mov	x1, x24
	mov	x0, x22
	bl	memcpy
	cbz	x25, .L2272
	b	.L2274
	.p2align 2,,3
.L2276:
	mov	x19, 9223372036854775804
.L2268:
	mov	x0, x19
	bl	_Znwm
	mov	x23, x0
	add	x19, x0, x19
	b	.L2275
	.p2align 2,,3
.L2269:
	cmp	x3, x1
	csel	x3, x3, x1, ls
	lsl	x19, x3, 2
	b	.L2268
.L2279:
	adrp	x0, .LC42
	add	x0, x0, :lo12:.LC42
	bl	_ZSt20__throw_length_errorPKc
	.cfi_endproc
.LFE12344:
	.size	_ZNSt6vectorIjSaIjEE17_M_realloc_insertIJRKjEEEvN9__gnu_cxx17__normal_iteratorIPjS1_EEDpOT_, .-_ZNSt6vectorIjSaIjEE17_M_realloc_insertIJRKjEEEvN9__gnu_cxx17__normal_iteratorIPjS1_EEDpOT_
	.section	.text._ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE9_M_rehashEmRS1_,"axG",@progbits,_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE9_M_rehashEmRS1_,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE9_M_rehashEmRS1_
	.type	_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE9_M_rehashEmRS1_, %function
_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE9_M_rehashEmRS1_:
.LFB12370:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA12370
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -32
	.cfi_offset 20, -24
	mov	x19, x1
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -16
	.cfi_offset 22, -8
	mov	x21, x0
	cmp	x1, 1
	beq	.L2303
	mov	x20, x2
	mov	x0, 1152921504606846975
	cmp	x1, x0
	bhi	.L2304
	lsl	x22, x1, 3
	mov	x0, x22
.LEHB178:
	bl	_Znwm
	mov	x20, x0
	mov	x2, x22
	mov	w1, 0
	bl	memset
	add	x8, x21, 48
.L2283:
	ldr	x4, [x21, 16]
	str	xzr, [x21, 16]
	cbz	x4, .L2285
	add	x7, x21, 16
	mov	x6, 0
	.p2align 3,,7
.L2286:
	ldr	x5, [x4, 8]
	mov	x3, x4
	ldr	x4, [x4]
	udiv	x2, x5, x19
	msub	x2, x2, x19, x5
	ldr	x1, [x20, x2, lsl 3]
	cbz	x1, .L2305
	ldr	x0, [x1]
	str	x0, [x3]
	ldr	x0, [x20, x2, lsl 3]
	str	x3, [x0]
	cbnz	x4, .L2286
.L2285:
	ldr	x0, [x21]
	cmp	x0, x8
	beq	.L2289
	bl	_ZdlPv
.L2289:
	stp	x20, x19, [x21]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L2305:
	.cfi_restore_state
	ldr	x0, [x21, 16]
	str	x0, [x3]
	str	x3, [x21, 16]
	str	x7, [x20, x2, lsl 3]
	ldr	x0, [x3]
	cbz	x0, .L2292
	str	x3, [x20, x6, lsl 3]
	mov	x6, x2
	cbnz	x4, .L2286
	b	.L2285
	.p2align 2,,3
.L2292:
	mov	x6, x2
	cbnz	x4, .L2286
	b	.L2285
	.p2align 2,,3
.L2303:
	mov	x20, x0
	str	xzr, [x20, 48]!
	mov	x8, x20
	b	.L2283
.L2304:
	bl	_ZSt17__throw_bad_allocv
.LEHE178:
.L2293:
	bl	__cxa_begin_catch
	ldr	x0, [x20]
	str	x0, [x21, 40]
.LEHB179:
	bl	__cxa_rethrow
.LEHE179:
.L2294:
	mov	x19, x0
	bl	__cxa_end_catch
	mov	x0, x19
.LEHB180:
	bl	_Unwind_Resume
.LEHE180:
	.cfi_endproc
.LFE12370:
	.section	.gcc_except_table
	.align	2
.LLSDA12370:
	.byte	0xff
	.byte	0x9b
	.uleb128 .LLSDATT12370-.LLSDATTD12370
.LLSDATTD12370:
	.byte	0x1
	.uleb128 .LLSDACSE12370-.LLSDACSB12370
.LLSDACSB12370:
	.uleb128 .LEHB178-.LFB12370
	.uleb128 .LEHE178-.LEHB178
	.uleb128 .L2293-.LFB12370
	.uleb128 0x1
	.uleb128 .LEHB179-.LFB12370
	.uleb128 .LEHE179-.LEHB179
	.uleb128 .L2294-.LFB12370
	.uleb128 0
	.uleb128 .LEHB180-.LFB12370
	.uleb128 .LEHE180-.LEHB180
	.uleb128 0
	.uleb128 0
.LLSDACSE12370:
	.byte	0x1
	.byte	0
	.align	2
	.4byte	0

.LLSDATT12370:
	.section	.text._ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE9_M_rehashEmRS1_,"axG",@progbits,_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE9_M_rehashEmRS1_,comdat
	.size	_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE9_M_rehashEmRS1_, .-_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE9_M_rehashEmRS1_
	.section	.text._ZNSt8__detail9_Map_baseImSt4pairIKmjESaIS3_ENS_10_Select1stESt8equal_toImESt4hashImENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_20_Prime_rehash_policyENS_17_Hashtable_traitsILb0ELb0ELb1EEELb1EEixERS2_,"axG",@progbits,_ZNSt8__detail9_Map_baseImSt4pairIKmjESaIS3_ENS_10_Select1stESt8equal_toImESt4hashImENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_20_Prime_rehash_policyENS_17_Hashtable_traitsILb0ELb0ELb1EEELb1EEixERS2_,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt8__detail9_Map_baseImSt4pairIKmjESaIS3_ENS_10_Select1stESt8equal_toImESt4hashImENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_20_Prime_rehash_policyENS_17_Hashtable_traitsILb0ELb0ELb1EEELb1EEixERS2_
	.type	_ZNSt8__detail9_Map_baseImSt4pairIKmjESaIS3_ENS_10_Select1stESt8equal_toImESt4hashImENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_20_Prime_rehash_policyENS_17_Hashtable_traitsILb0ELb0ELb1EEELb1EEixERS2_, %function
_ZNSt8__detail9_Map_baseImSt4pairIKmjESaIS3_ENS_10_Select1stESt8equal_toImESt4hashImENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_20_Prime_rehash_policyENS_17_Hashtable_traitsILb0ELb0ELb1EEELb1EEixERS2_:
.LFB11881:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA11881
	stp	x29, x30, [sp, -80]!
	.cfi_def_cfa_offset 80
	.cfi_offset 29, -80
	.cfi_offset 30, -72
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -48
	.cfi_offset 22, -40
	ldr	x21, [x1]
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -64
	.cfi_offset 20, -56
	mov	x19, x0
	ldr	x5, [x0, 8]
	ldr	x0, [x0]
	udiv	x2, x21, x5
	msub	x2, x2, x5, x21
	lsl	x22, x2, 3
	ldr	x6, [x0, x2, lsl 3]
	str	x23, [sp, 48]
	.cfi_offset 23, -32
	mov	x23, x1
	cbz	x6, .L2307
	ldr	x3, [x6]
	ldr	x0, [x3, 8]
	cmp	x21, x0
	beq	.L2308
.L2331:
	ldr	x4, [x3]
	cbz	x4, .L2307
	ldr	x0, [x4, 8]
	mov	x6, x3
	udiv	x3, x0, x5
	msub	x3, x3, x5, x0
	cmp	x2, x3
	bne	.L2307
	mov	x3, x4
	cmp	x21, x0
	bne	.L2331
.L2308:
	ldr	x1, [x6]
	add	x0, x1, 16
	cbz	x1, .L2307
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 80
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L2307:
	.cfi_restore_state
	mov	x0, 24
.LEHB181:
	bl	_Znwm
.LEHE181:
	ldr	x4, [x23]
	mov	x20, x0
	ldr	x1, [x19, 8]
	add	x0, x19, 32
	ldr	x2, [x19, 24]
	mov	x3, 1
	ldr	x5, [x19, 40]
	stp	xzr, x4, [x20]
	str	wzr, [x20, 16]
	str	x5, [sp, 72]
.LEHB182:
	bl	_ZNKSt8__detail20_Prime_rehash_policy14_M_need_rehashEmmm
	tst	w0, 255
	bne	.L2332
	ldr	x0, [x19]
	add	x2, x0, x22
	ldr	x1, [x0, x22]
	cbz	x1, .L2312
.L2333:
	ldr	x1, [x1]
	str	x1, [x20]
	ldr	x0, [x0, x22]
	str	x20, [x0]
.L2313:
	ldr	x1, [x19, 24]
	add	x0, x20, 16
	ldp	x21, x22, [sp, 32]
	add	x1, x1, 1
	str	x1, [x19, 24]
	ldp	x19, x20, [sp, 16]
	ldr	x23, [sp, 48]
	ldp	x29, x30, [sp], 80
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L2332:
	.cfi_restore_state
	add	x2, sp, 72
	mov	x0, x19
	bl	_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE9_M_rehashEmRS1_
.LEHE182:
	ldr	x0, [x19, 8]
	udiv	x22, x21, x0
	msub	x22, x22, x0, x21
	ldr	x0, [x19]
	lsl	x22, x22, 3
	add	x2, x0, x22
	ldr	x1, [x0, x22]
	cbnz	x1, .L2333
.L2312:
	ldr	x1, [x19, 16]
	str	x1, [x20]
	str	x20, [x19, 16]
	cbz	x1, .L2314
	ldr	x4, [x1, 8]
	ldr	x3, [x19, 8]
	udiv	x1, x4, x3
	msub	x1, x1, x3, x4
	str	x20, [x0, x1, lsl 3]
.L2314:
	add	x0, x19, 16
	str	x0, [x2]
	b	.L2313
.L2317:
	mov	x19, x0
	mov	x0, x20
	bl	_ZdlPv
	mov	x0, x19
.LEHB183:
	bl	_Unwind_Resume
.LEHE183:
	.cfi_endproc
.LFE11881:
	.section	.gcc_except_table
.LLSDA11881:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE11881-.LLSDACSB11881
.LLSDACSB11881:
	.uleb128 .LEHB181-.LFB11881
	.uleb128 .LEHE181-.LEHB181
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB182-.LFB11881
	.uleb128 .LEHE182-.LEHB182
	.uleb128 .L2317-.LFB11881
	.uleb128 0
	.uleb128 .LEHB183-.LFB11881
	.uleb128 .LEHE183-.LEHB183
	.uleb128 0
	.uleb128 0
.LLSDACSE11881:
	.section	.text._ZNSt8__detail9_Map_baseImSt4pairIKmjESaIS3_ENS_10_Select1stESt8equal_toImESt4hashImENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_20_Prime_rehash_policyENS_17_Hashtable_traitsILb0ELb0ELb1EEELb1EEixERS2_,"axG",@progbits,_ZNSt8__detail9_Map_baseImSt4pairIKmjESaIS3_ENS_10_Select1stESt8equal_toImESt4hashImENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_20_Prime_rehash_policyENS_17_Hashtable_traitsILb0ELb0ELb1EEELb1EEixERS2_,comdat
	.size	_ZNSt8__detail9_Map_baseImSt4pairIKmjESaIS3_ENS_10_Select1stESt8equal_toImESt4hashImENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_20_Prime_rehash_policyENS_17_Hashtable_traitsILb0ELb0ELb1EEELb1EEixERS2_, .-_ZNSt8__detail9_Map_baseImSt4pairIKmjESaIS3_ENS_10_Select1stESt8equal_toImESt4hashImENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_20_Prime_rehash_policyENS_17_Hashtable_traitsILb0ELb0ELb1EEELb1EEixERS2_
	.section	.text._ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRKjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_,"axG",@progbits,_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRKjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRKjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.type	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRKjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_, %function
_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRKjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_:
.LFB12407:
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	ldp	x24, x23, [x0]
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	mov	x21, x0
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	sub	x0, x23, x24
	stp	x27, x28, [sp, 80]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	.cfi_offset 27, -16
	.cfi_offset 28, -8
	mov	x27, x2
	asr	x0, x0, 3
	mov	x2, 1152921504606846975
	cmp	x0, x2
	beq	.L2352
	cmp	x0, 0
	mov	x19, x1
	sub	x26, x1, x24
	csinc	x1, x0, xzr, ne
	mov	x28, x3
	adds	x1, x1, x0
	bcs	.L2345
	cbnz	x1, .L2339
	mov	x25, 8
	mov	x22, 0
	mov	x20, 0
.L2344:
	ldr	s0, [x27]
	add	x0, x20, x26
	ldr	w1, [x28]
	str	s0, [x20, x26]
	str	w1, [x0, 4]
	cmp	x19, x24
	beq	.L2340
	mov	x4, x20
	mov	x3, x24
	.p2align 3,,7
.L2341:
	ldr	x5, [x3], 8
	str	x5, [x4], 8
	cmp	x3, x19
	bne	.L2341
	add	x26, x26, 8
	add	x25, x20, x26
.L2340:
	cmp	x19, x23
	beq	.L2342
	sub	x2, x23, x19
	mov	x0, x25
	mov	x1, x19
	add	x25, x25, x2
	bl	memcpy
.L2342:
	cbz	x24, .L2343
	mov	x0, x24
	bl	_ZdlPv
.L2343:
	ldp	x23, x24, [sp, 48]
	ldp	x27, x28, [sp, 80]
	stp	x20, x25, [x21]
	str	x22, [x21, 16]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L2345:
	.cfi_restore_state
	mov	x22, 9223372036854775800
.L2338:
	mov	x0, x22
	bl	_Znwm
	mov	x20, x0
	add	x22, x0, x22
	add	x25, x0, 8
	b	.L2344
.L2339:
	cmp	x1, x2
	csel	x1, x1, x2, ls
	lsl	x22, x1, 3
	b	.L2338
.L2352:
	adrp	x0, .LC42
	add	x0, x0, :lo12:.LC42
	bl	_ZSt20__throw_length_errorPKc
	.cfi_endproc
.LFE12407:
	.size	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRKjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_, .-_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRKjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.section	.text._ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_,"axG",@progbits,_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.type	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_, %function
_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_:
.LFB12502:
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	ldp	x24, x23, [x0]
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	mov	x21, x0
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	sub	x0, x23, x24
	stp	x27, x28, [sp, 80]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	.cfi_offset 27, -16
	.cfi_offset 28, -8
	mov	x27, x2
	asr	x0, x0, 3
	mov	x2, 1152921504606846975
	cmp	x0, x2
	beq	.L2371
	cmp	x0, 0
	mov	x19, x1
	sub	x26, x1, x24
	csinc	x1, x0, xzr, ne
	mov	x28, x3
	adds	x1, x1, x0
	bcs	.L2364
	cbnz	x1, .L2358
	mov	x25, 8
	mov	x22, 0
	mov	x20, 0
.L2363:
	ldr	s0, [x27]
	add	x0, x20, x26
	ldr	w1, [x28]
	str	s0, [x20, x26]
	str	w1, [x0, 4]
	cmp	x19, x24
	beq	.L2359
	mov	x4, x20
	mov	x3, x24
	.p2align 3,,7
.L2360:
	ldr	x5, [x3], 8
	str	x5, [x4], 8
	cmp	x3, x19
	bne	.L2360
	add	x26, x26, 8
	add	x25, x20, x26
.L2359:
	cmp	x19, x23
	beq	.L2361
	sub	x2, x23, x19
	mov	x0, x25
	mov	x1, x19
	add	x25, x25, x2
	bl	memcpy
.L2361:
	cbz	x24, .L2362
	mov	x0, x24
	bl	_ZdlPv
.L2362:
	ldp	x23, x24, [sp, 48]
	ldp	x27, x28, [sp, 80]
	stp	x20, x25, [x21]
	str	x22, [x21, 16]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L2364:
	.cfi_restore_state
	mov	x22, 9223372036854775800
.L2357:
	mov	x0, x22
	bl	_Znwm
	mov	x20, x0
	add	x22, x0, x22
	add	x25, x0, 8
	b	.L2363
.L2358:
	cmp	x1, x2
	csel	x1, x1, x2, ls
	lsl	x22, x1, 3
	b	.L2357
.L2371:
	adrp	x0, .LC42
	add	x0, x0, :lo12:.LC42
	bl	_ZSt20__throw_length_errorPKc
	.cfi_endproc
.LFE12502:
	.size	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_, .-_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.section	.rodata.str1.8
	.align	3
.LC74:
	.string	"Should be not be more than M_ candidates returned by the heuristic"
	.align	3
.LC75:
	.string	"The newly inserted element should have blank link list"
	.align	3
.LC76:
	.string	"Possible memory corruption"
	.align	3
.LC77:
	.string	"Trying to make a link on a non-existent level"
	.align	3
.LC78:
	.string	"Bad value of sz_link_list_other"
	.align	3
.LC79:
	.string	"Trying to connect an element to itself"
	.text
	.align	2
	.p2align 4,,11
	.type	_ZN7hnswlib15HierarchicalNSWIfE25mutuallyConnectNewElementEPKvjRSt14priority_queueISt4pairIfjESt6vectorIS6_SaIS6_EENS1_14CompareByFirstEEib.isra.0, %function
_ZN7hnswlib15HierarchicalNSWIfE25mutuallyConnectNewElementEPKvjRSt14priority_queueISt4pairIfjESt6vectorIS6_SaIS6_EENS1_14CompareByFirstEEib.isra.0:
.LFB13068:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA13068
	stp	x29, x30, [sp, -208]!
	.cfi_def_cfa_offset 208
	.cfi_offset 29, -208
	.cfi_offset 30, -200
	cmp	w3, 0
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -176
	.cfi_offset 22, -168
	mov	x21, x2
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -144
	.cfi_offset 26, -136
	mov	w26, w3
	ldp	x2, x3, [x0, 48]
	stp	x27, x28, [sp, 80]
	.cfi_offset 27, -128
	.cfi_offset 28, -120
	and	w28, w4, 255
	ldr	x27, [x0, 64]
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -192
	.cfi_offset 20, -184
	mov	x19, x0
	csel	x27, x27, x3, eq
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -160
	.cfi_offset 24, -152
	str	w1, [sp, 124]
	mov	x1, x21
.LEHB184:
	bl	_ZN7hnswlib15HierarchicalNSWIfE24getNeighborsByHeuristic2ERSt14priority_queueISt4pairIfjESt6vectorIS4_SaIS4_EENS1_14CompareByFirstEEm
.LEHE184:
	ldp	x2, x1, [x21]
	ldr	x0, [x19, 48]
	sub	x3, x1, x2
	cmp	x0, x3, asr 3
	bcc	.L2520
	stp	xzr, xzr, [sp, 152]
	mov	x3, 2305843009213693951
	str	xzr, [sp, 168]
	cmp	x0, x3
	bhi	.L2521
	cbnz	x0, .L2522
	mov	x20, 0
.L2376:
	cmp	x1, x2
	bne	.L2384
	b	.L2380
	.p2align 2,,3
.L2523:
	ldr	w0, [x2, 4]
	str	w0, [x20], 4
	mov	x0, x21
	str	x20, [sp, 160]
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	ldp	x2, x0, [x21]
	ldr	x20, [sp, 160]
	cmp	x0, x2
	beq	.L2380
.L2384:
	ldr	x0, [sp, 168]
	cmp	x0, x20
	bne	.L2523
	add	x2, x2, 4
	mov	x1, x20
	add	x0, sp, 152
.LEHB185:
	bl	_ZNSt6vectorIjSaIjEE17_M_realloc_insertIJRKjEEEvN9__gnu_cxx17__normal_iteratorIPjS1_EEDpOT_
	mov	x0, x21
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	ldp	x2, x0, [x21]
	ldr	x20, [sp, 160]
	cmp	x0, x2
	bne	.L2384
.L2380:
	ldr	w0, [sp, 124]
	mov	w3, 48
	ldr	x2, [x19, 192]
	uxtw	x1, w0
	ldr	w4, [x20, -4]
	str	w4, [sp, 120]
	umaddl	x0, w0, w3, x2
	strb	wzr, [sp, 184]
	str	x0, [sp, 176]
	cbnz	w28, .L2524
	cbnz	w26, .L2389
.L2537:
	ldr	x2, [x19, 24]
	ldr	x0, [x19, 240]
	ldr	x3, [x19, 256]
	madd	x1, x1, x2, x0
	add	x3, x3, x1
.L2390:
	ldr	w0, [x3]
	cmp	w0, 0
	ccmp	w28, 0, 0, ne
	beq	.L2525
	ldp	x2, x7, [sp, 152]
	mov	x1, 1
	sub	x5, x7, x2
	sub	x6, x2, #4
	asr	x5, x5, 2
	strh	w5, [x3]
	cbnz	x5, .L2392
	b	.L2397
	.p2align 2,,3
.L2448:
	mov	x1, x0
.L2392:
	ldr	w0, [x3, x1, lsl 2]
	cmp	w0, 0
	ccmp	w28, 0, 0, ne
	beq	.L2526
	ldr	w0, [x6, x1, lsl 2]
	ldr	x4, [x19, 272]
	ldr	w4, [x4, w0, uxtw 2]
	cmp	w26, w4
	bgt	.L2527
	str	w0, [x3, x1, lsl 2]
	add	x0, x1, 1
	cmp	x5, x1
	bne	.L2448
.L2397:
	ldrb	w0, [sp, 184]
	cbnz	w0, .L2528
.L2394:
	cmp	x2, x7
	beq	.L2398
	sub	w0, w26, #1
	add	x1, x19, 192
	mov	x24, 0
	sxtw	x0, w0
	stp	x1, x0, [sp, 104]
	b	.L2428
	.p2align 2,,3
.L2534:
	ldr	x1, [x19, 24]
	ldr	x2, [x19, 240]
	ldr	x20, [x19, 256]
	madd	x1, x4, x1, x2
	add	x20, x20, x1
.L2402:
	ldrh	w2, [x20]
	and	x22, x2, 65535
	cmp	x27, x2, uxth
	bcc	.L2529
	ldr	w1, [sp, 124]
	cmp	w1, w0
	beq	.L2530
	ldr	x0, [x19, 272]
	ldr	w0, [x0, x4, lsl 2]
	cmp	w26, w0
	bgt	.L2531
	add	x21, x20, 4
	cbnz	w28, .L2532
.L2406:
	cmp	x22, x27
	bcs	.L2409
	uxtw	x0, w2
	add	w2, w2, 1
	str	w1, [x21, x0, lsl 2]
	strh	w2, [x20]
.L2407:
	ldr	x0, [sp, 136]
	cbz	x0, .L2427
	ldr	x1, [sp, 96]
	cbz	x1, .L2427
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
.L2427:
	ldp	x2, x0, [sp, 152]
	add	x24, x24, 1
	sub	x0, x0, x2
	cmp	x24, x0, asr 2
	bcs	.L2398
.L2428:
	ldr	x1, [sp, 104]
	mov	w3, 48
	ldr	w0, [x2, x24, lsl 2]
	lsl	x25, x24, 2
	strb	wzr, [sp, 144]
	ldr	x1, [x1]
	umaddl	x0, w0, w3, x1
	str	x0, [sp, 136]
	cbz	x0, .L2533
	adrp	x1, .LC36
	ldr	x1, [x1, #:lo12:.LC36]
	str	x1, [sp, 96]
	cbz	x1, .L2400
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L2514
	ldr	x2, [sp, 152]
.L2400:
	mov	w0, 1
	strb	w0, [sp, 144]
	ldr	w0, [x2, x25]
	uxtw	x4, w0
	cbz	w26, .L2534
	ldr	x1, [x19, 264]
	ldr	x20, [x19, 32]
	ldr	x1, [x1, x4, lsl 3]
	ldr	x2, [sp, 112]
	madd	x20, x2, x20, x1
	b	.L2402
.L2522:
	lsl	x22, x0, 2
	mov	x0, x22
	bl	_Znwm
.LEHE185:
	ldp	x23, x2, [sp, 152]
	mov	x20, x0
	sub	x2, x2, x23
	cmp	x2, 0
	bgt	.L2535
	cbnz	x23, .L2378
.L2379:
	add	x0, x20, x22
	stp	x20, x20, [sp, 152]
	str	x0, [sp, 168]
	ldp	x2, x1, [x21]
	b	.L2376
.L2535:
	mov	x1, x23
	bl	memmove
.L2378:
	mov	x0, x23
	bl	_ZdlPv
	b	.L2379
.L2524:
	cbz	x0, .L2536
	adrp	x2, .LC36
	ldr	x2, [x2, #:lo12:.LC36]
	cbz	x2, .L2387
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L2388
	ldr	w1, [sp, 124]
.L2387:
	mov	w0, 1
	strb	w0, [sp, 184]
	cbz	w26, .L2537
.L2389:
	ldr	x0, [x19, 264]
	sub	w3, w26, #1
	ldr	x2, [x19, 32]
	sxtw	x3, w3
	ldr	x0, [x0, x1, lsl 3]
	madd	x3, x3, x2, x0
	b	.L2390
	.p2align 2,,3
.L2532:
	cbz	x22, .L2406
	mov	x0, 1
	b	.L2408
	.p2align 2,,3
.L2538:
	add	x3, x0, 1
	cmp	x22, x0
	beq	.L2406
	mov	x0, x3
.L2408:
	ldr	w3, [x20, x0, lsl 2]
	cmp	w1, w3
	bne	.L2538
	b	.L2407
	.p2align 2,,3
.L2409:
	ldr	x3, [x19, 24]
	uxtw	x0, w1
	ldr	x5, [x19, 232]
	ldp	x6, x2, [x19, 304]
	madd	x0, x0, x3, x5
	madd	x3, x3, x4, x5
	ldr	x1, [x19, 256]
	add	x0, x1, x0
	add	x1, x1, x3
.LEHB186:
	blr	x6
.LEHE186:
	add	x0, sp, 176
	add	x3, sp, 124
	add	x2, sp, 128
	mov	x1, 0
	str	s0, [sp, 128]
	stp	xzr, xzr, [sp, 176]
	str	xzr, [sp, 192]
.LEHB187:
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	ldp	x3, x1, [sp, 176]
	sub	x2, x1, x3
	ldr	w7, [x1, -4]
	ldr	s1, [x1, -8]
	asr	x0, x2, 3
	sub	x1, x0, #2
	sub	x0, x0, #1
	add	x1, x1, x1, lsr 63
	asr	x1, x1, 1
	cmp	x0, 0
	ble	.L2410
	.p2align 3,,7
.L2413:
	lsl	x2, x1, 3
	lsl	x0, x0, 3
	add	x5, x3, x2
	add	x4, x3, x0
	ldr	s0, [x3, x2]
	fcmpe	s1, s0
	bgt	.L2465
.L2411:
	str	w7, [x4, 4]
	mov	x23, 0
	str	s1, [x4]
	cbz	x22, .L2422
	.p2align 3,,7
.L2423:
	ldr	x1, [sp, 152]
	ldr	w0, [x21]
	ldr	x5, [x19, 24]
	ldr	w1, [x1, x25]
	ldr	x4, [x19, 232]
	ldp	x6, x2, [x19, 304]
	ldr	x3, [x19, 256]
	madd	x0, x0, x5, x4
	madd	x1, x1, x5, x4
	add	x0, x3, x0
	add	x1, x3, x1
	blr	x6
	ldp	x1, x0, [sp, 184]
	str	s0, [sp, 132]
	cmp	x1, x0
	beq	.L2416
	ldr	w7, [x21]
	add	x0, x1, 8
	str	s0, [x1]
	str	w7, [x1, 4]
	str	x0, [sp, 184]
.L2417:
	ldr	x3, [sp, 176]
	sub	x2, x0, x3
	asr	x0, x2, 3
	sub	x1, x0, #2
	sub	x0, x0, #1
	add	x1, x1, x1, lsr 63
	asr	x1, x1, 1
	cmp	x0, 0
	ble	.L2418
	.p2align 3,,7
.L2421:
	lsl	x2, x1, 3
	lsl	x0, x0, 3
	add	x5, x3, x2
	add	x4, x3, x0
	ldr	s1, [x3, x2]
	fcmpe	s1, s0
	bmi	.L2466
	add	x23, x23, 1
	str	s0, [x4]
	str	w7, [x4, 4]
	add	x21, x21, 4
	cmp	x22, x23
	bne	.L2423
.L2422:
	mov	x2, x27
	add	x1, sp, 176
	mov	x0, x19
	bl	_ZN7hnswlib15HierarchicalNSWIfE24getNeighborsByHeuristic2ERSt14priority_queueISt4pairIfjESt6vectorIS4_SaIS4_EENS1_14CompareByFirstEEm
	ldp	x0, x1, [sp, 176]
	cmp	x1, x0
	beq	.L2453
	mov	x21, 1
	.p2align 3,,7
.L2425:
	ldr	w1, [x0, 4]
	add	x0, sp, 176
	str	w1, [x20, x21, lsl 2]
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	ldp	x0, x1, [sp, 176]
	mov	x2, x21
	add	x21, x21, 1
	cmp	x1, x0
	bne	.L2425
	and	w2, w2, 65535
.L2424:
	strh	w2, [x20]
	cbz	x0, .L2426
	bl	_ZdlPv
.L2426:
	ldrb	w0, [sp, 144]
	cbnz	w0, .L2407
	ldp	x2, x0, [sp, 152]
	add	x24, x24, 1
	sub	x0, x0, x2
	cmp	x24, x0, asr 2
	bcc	.L2428
.L2398:
	cbz	x2, .L2372
	mov	x0, x2
	bl	_ZdlPv
.L2372:
	ldr	w0, [sp, 120]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 208
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L2465:
	.cfi_restore_state
	sub	x2, x1, #1
	ldr	w6, [x5, 4]
	str	s0, [x3, x0]
	mov	x0, x1
	add	x2, x2, x2, lsr 63
	str	w6, [x4, 4]
	asr	x1, x2, 1
	cmp	x0, 0
	bgt	.L2413
	mov	x4, x5
	b	.L2411
	.p2align 2,,3
.L2466:
	sub	x2, x1, #1
	ldr	w6, [x5, 4]
	str	s1, [x3, x0]
	mov	x0, x1
	add	x2, x2, x2, lsr 63
	str	w6, [x4, 4]
	asr	x1, x2, 1
	cmp	x0, 0
	bgt	.L2421
	mov	x4, x5
	add	x23, x23, 1
	add	x21, x21, 4
	str	s0, [x4]
	str	w7, [x4, 4]
	cmp	x22, x23
	bne	.L2423
	b	.L2422
	.p2align 2,,3
.L2416:
	mov	x3, x21
	add	x2, sp, 132
	add	x0, sp, 176
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE187:
	ldr	x0, [sp, 184]
	ldr	w7, [x0, -4]
	ldr	s0, [x0, -8]
	b	.L2417
.L2418:
	sub	x0, x2, #8
	add	x23, x23, 1
	add	x4, x3, x0
	add	x21, x21, 4
	str	s0, [x4]
	str	w7, [x4, 4]
	cmp	x22, x23
	bne	.L2423
	b	.L2422
.L2528:
	add	x0, sp, 176
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
	ldp	x2, x7, [sp, 152]
	b	.L2394
.L2453:
	mov	w2, 0
	b	.L2424
.L2410:
	sub	x2, x2, #8
	add	x4, x3, x2
	b	.L2411
.L2388:
.LEHB188:
	bl	_ZSt20__throw_system_errori
.LEHE188:
.L2521:
	adrp	x0, .LC43
	add	x0, x0, :lo12:.LC43
.LEHB189:
	bl	_ZSt20__throw_length_errorPKc
.L2514:
	bl	_ZSt20__throw_system_errori
.LEHE189:
.L2536:
	mov	w0, 1
.LEHB190:
	bl	_ZSt20__throw_system_errori
.LEHE190:
	.p2align 2,,3
.L2533:
	mov	w0, 1
.LEHB191:
	bl	_ZSt20__throw_system_errori
.LEHE191:
.L2460:
	mov	x19, x0
.L2432:
	ldrb	w0, [sp, 184]
	cbz	w0, .L2436
	add	x0, sp, 176
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
.L2436:
	ldr	x0, [sp, 152]
	cbz	x0, .L2444
	bl	_ZdlPv
.L2444:
	mov	x0, x19
.LEHB192:
	bl	_Unwind_Resume
.LEHE192:
.L2529:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC78
	mov	x20, x0
	add	x1, x1, :lo12:.LC78
.LEHB193:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE193:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x20
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB194:
	bl	__cxa_throw
.LEHE194:
.L2530:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC79
	mov	x20, x0
	add	x1, x1, :lo12:.LC79
.LEHB195:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE195:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x20
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB196:
	bl	__cxa_throw
.LEHE196:
.L2459:
.L2518:
	mov	x19, x0
	mov	x0, x20
	bl	__cxa_free_exception
.L2438:
	ldrb	w0, [sp, 144]
	cbz	w0, .L2436
	add	x0, sp, 136
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
	b	.L2436
.L2458:
	b	.L2518
.L2455:
	mov	x19, x0
	b	.L2438
.L2456:
	ldr	x1, [sp, 176]
	mov	x19, x0
	cbz	x1, .L2438
	mov	x0, x1
	bl	_ZdlPv
	b	.L2438
.L2454:
	mov	x19, x0
	b	.L2436
.L2525:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC75
	mov	x20, x0
	add	x1, x1, :lo12:.LC75
.LEHB197:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE197:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x20
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB198:
	bl	__cxa_throw
.LEHE198:
.L2463:
.L2517:
	mov	x19, x0
	mov	x0, x20
	bl	__cxa_free_exception
	b	.L2432
.L2520:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC74
	mov	x19, x0
	add	x1, x1, :lo12:.LC74
.LEHB199:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE199:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x19
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB200:
	bl	__cxa_throw
.LEHE200:
.L2526:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC76
	mov	x20, x0
	add	x1, x1, :lo12:.LC76
.LEHB201:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE201:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x20
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB202:
	bl	__cxa_throw
.LEHE202:
.L2531:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC77
	mov	x20, x0
	add	x1, x1, :lo12:.LC77
.LEHB203:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE203:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x20
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB204:
	bl	__cxa_throw
.LEHE204:
.L2527:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC77
	mov	x20, x0
	add	x1, x1, :lo12:.LC77
.LEHB205:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE205:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x20
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB206:
	bl	__cxa_throw
.LEHE206:
.L2464:
	mov	x1, x0
	mov	x0, x19
	mov	x19, x1
	bl	__cxa_free_exception
	mov	x0, x19
.LEHB207:
	bl	_Unwind_Resume
.LEHE207:
.L2457:
	b	.L2518
.L2462:
	b	.L2517
.L2461:
	b	.L2517
	.cfi_endproc
.LFE13068:
	.section	.gcc_except_table
.LLSDA13068:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE13068-.LLSDACSB13068
.LLSDACSB13068:
	.uleb128 .LEHB184-.LFB13068
	.uleb128 .LEHE184-.LEHB184
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB185-.LFB13068
	.uleb128 .LEHE185-.LEHB185
	.uleb128 .L2454-.LFB13068
	.uleb128 0
	.uleb128 .LEHB186-.LFB13068
	.uleb128 .LEHE186-.LEHB186
	.uleb128 .L2455-.LFB13068
	.uleb128 0
	.uleb128 .LEHB187-.LFB13068
	.uleb128 .LEHE187-.LEHB187
	.uleb128 .L2456-.LFB13068
	.uleb128 0
	.uleb128 .LEHB188-.LFB13068
	.uleb128 .LEHE188-.LEHB188
	.uleb128 .L2460-.LFB13068
	.uleb128 0
	.uleb128 .LEHB189-.LFB13068
	.uleb128 .LEHE189-.LEHB189
	.uleb128 .L2454-.LFB13068
	.uleb128 0
	.uleb128 .LEHB190-.LFB13068
	.uleb128 .LEHE190-.LEHB190
	.uleb128 .L2460-.LFB13068
	.uleb128 0
	.uleb128 .LEHB191-.LFB13068
	.uleb128 .LEHE191-.LEHB191
	.uleb128 .L2454-.LFB13068
	.uleb128 0
	.uleb128 .LEHB192-.LFB13068
	.uleb128 .LEHE192-.LEHB192
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB193-.LFB13068
	.uleb128 .LEHE193-.LEHB193
	.uleb128 .L2459-.LFB13068
	.uleb128 0
	.uleb128 .LEHB194-.LFB13068
	.uleb128 .LEHE194-.LEHB194
	.uleb128 .L2455-.LFB13068
	.uleb128 0
	.uleb128 .LEHB195-.LFB13068
	.uleb128 .LEHE195-.LEHB195
	.uleb128 .L2458-.LFB13068
	.uleb128 0
	.uleb128 .LEHB196-.LFB13068
	.uleb128 .LEHE196-.LEHB196
	.uleb128 .L2455-.LFB13068
	.uleb128 0
	.uleb128 .LEHB197-.LFB13068
	.uleb128 .LEHE197-.LEHB197
	.uleb128 .L2463-.LFB13068
	.uleb128 0
	.uleb128 .LEHB198-.LFB13068
	.uleb128 .LEHE198-.LEHB198
	.uleb128 .L2460-.LFB13068
	.uleb128 0
	.uleb128 .LEHB199-.LFB13068
	.uleb128 .LEHE199-.LEHB199
	.uleb128 .L2464-.LFB13068
	.uleb128 0
	.uleb128 .LEHB200-.LFB13068
	.uleb128 .LEHE200-.LEHB200
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB201-.LFB13068
	.uleb128 .LEHE201-.LEHB201
	.uleb128 .L2462-.LFB13068
	.uleb128 0
	.uleb128 .LEHB202-.LFB13068
	.uleb128 .LEHE202-.LEHB202
	.uleb128 .L2460-.LFB13068
	.uleb128 0
	.uleb128 .LEHB203-.LFB13068
	.uleb128 .LEHE203-.LEHB203
	.uleb128 .L2457-.LFB13068
	.uleb128 0
	.uleb128 .LEHB204-.LFB13068
	.uleb128 .LEHE204-.LEHB204
	.uleb128 .L2455-.LFB13068
	.uleb128 0
	.uleb128 .LEHB205-.LFB13068
	.uleb128 .LEHE205-.LEHB205
	.uleb128 .L2461-.LFB13068
	.uleb128 0
	.uleb128 .LEHB206-.LFB13068
	.uleb128 .LEHE206-.LEHB206
	.uleb128 .L2460-.LFB13068
	.uleb128 0
	.uleb128 .LEHB207-.LFB13068
	.uleb128 .LEHE207-.LEHB207
	.uleb128 0
	.uleb128 0
.LLSDACSE13068:
	.text
	.size	_ZN7hnswlib15HierarchicalNSWIfE25mutuallyConnectNewElementEPKvjRSt14priority_queueISt4pairIfjESt6vectorIS6_SaIS6_EENS1_14CompareByFirstEEib.isra.0, .-_ZN7hnswlib15HierarchicalNSWIfE25mutuallyConnectNewElementEPKvjRSt14priority_queueISt4pairIfjESt6vectorIS6_SaIS6_EENS1_14CompareByFirstEEib.isra.0
	.section	.rodata._ZN7hnswlib15HierarchicalNSWIfE15searchBaseLayerEjPKvi.str1.8,"aMS",@progbits,1
	.align	3
.LC80:
	.string	"cannot create std::deque larger than max_size()"
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE15searchBaseLayerEjPKvi,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE15searchBaseLayerEjPKvi,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib15HierarchicalNSWIfE15searchBaseLayerEjPKvi
	.type	_ZN7hnswlib15HierarchicalNSWIfE15searchBaseLayerEjPKvi, %function
_ZN7hnswlib15HierarchicalNSWIfE15searchBaseLayerEjPKvi:
.LFB11871:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA11871
	stp	x29, x30, [sp, -208]!
	.cfi_def_cfa_offset 208
	.cfi_offset 29, -208
	.cfi_offset 30, -200
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -192
	.cfi_offset 20, -184
	mov	x19, x0
	ldr	x0, [x0, 112]
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -176
	.cfi_offset 22, -168
	mov	x21, x8
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	.cfi_offset 23, -160
	.cfi_offset 24, -152
	.cfi_offset 25, -144
	.cfi_offset 26, -136
	mov	x26, x2
	stp	x27, x28, [sp, 80]
	.cfi_offset 27, -128
	.cfi_offset 28, -120
	mov	w28, w3
	str	d8, [sp, 96]
	.cfi_offset 72, -112
	str	w1, [sp, 140]
.LEHB208:
	bl	_ZN7hnswlib15VisitedListPool18getFreeVisitedListEv
.LEHE208:
	ldr	w2, [sp, 140]
	ldrh	w23, [x0]
	str	x0, [sp, 128]
	ldr	x22, [x0, 8]
	stp	xzr, xzr, [sp, 176]
	ldr	x0, [x19, 24]
	str	xzr, [sp, 192]
	ldr	x3, [x19, 256]
	mul	x2, x2, x0
	ldr	x1, [x19, 240]
	add	x0, x3, x2
	stp	xzr, xzr, [x21]
	add	x0, x0, x1
	str	xzr, [x21, 16]
	ldrb	w0, [x0, 2]
	tbnz	x0, 0, .L2540
	ldr	x1, [x19, 232]
	mov	x0, x26
	ldr	x4, [x19, 304]
	add	x1, x2, x1
	ldr	x2, [x19, 312]
	add	x1, x3, x1
.LEHB209:
	blr	x4
	ldp	x1, x0, [x21, 8]
	str	s0, [sp, 156]
	fmov	s8, s0
	cmp	x1, x0
	beq	.L2541
	ldr	w7, [sp, 140]
	fmov	s2, s0
	str	s0, [x1]
	add	x0, x1, 8
	str	w7, [x1, 4]
	str	x0, [x21, 8]
.L2542:
	ldr	x3, [x21]
	sub	x2, x0, x3
	asr	x0, x2, 3
	sub	x1, x0, #2
	sub	x0, x0, #1
	add	x1, x1, x1, lsr 63
	asr	x1, x1, 1
	cmp	x0, 0
	ble	.L2543
	.p2align 3,,7
.L2546:
	lsl	x2, x1, 3
	lsl	x0, x0, 3
	add	x5, x3, x2
	add	x4, x3, x0
	ldr	s0, [x3, x2]
	fcmpe	s0, s2
	bmi	.L2611
.L2544:
	ldp	x1, x0, [sp, 184]
	fneg	s1, s8
	str	w7, [x4, 4]
	str	s2, [x4]
	str	s1, [sp, 160]
	cmp	x1, x0
	beq	.L2547
.L2656:
	ldr	w9, [sp, 140]
	add	x7, x1, 8
	str	s1, [x1]
	mov	w8, w9
	str	w9, [x1, 4]
	str	x7, [sp, 184]
.L2548:
	ldr	x0, [sp, 176]
	sub	x3, x7, x0
	asr	x1, x3, 3
	sub	x2, x1, #2
	sub	x1, x1, #1
	add	x2, x2, x2, lsr 63
	asr	x2, x2, 1
	cmp	x1, 0
	ble	.L2549
	.p2align 3,,7
.L2552:
	lsl	x3, x2, 3
	lsl	x1, x1, 3
	add	x5, x0, x3
	add	x4, x0, x1
	ldr	s0, [x0, x3]
	fcmpe	s0, s1
	bmi	.L2612
.L2550:
	str	w9, [x4, 4]
	str	s1, [x4]
.L2553:
	strh	w23, [x22, w8, uxtw 1]
	cmp	x0, x7
	beq	.L2655
	sub	w1, w28, #1
	sxtw	x1, w1
	str	x1, [sp, 120]
	.p2align 3,,7
.L2587:
	ldr	s0, [x0]
	ldr	w20, [x0, 4]
	fneg	s0, s0
	fcmpe	s0, s8
	bgt	.L2613
	b	.L2555
	.p2align 2,,3
.L2611:
	sub	x2, x1, #1
	ldr	w6, [x5, 4]
	str	s0, [x3, x0]
	mov	x0, x1
	add	x2, x2, x2, lsr 63
	str	w6, [x4, 4]
	asr	x1, x2, 1
	cmp	x0, 0
	bgt	.L2546
	mov	x4, x5
	fneg	s1, s8
	ldp	x1, x0, [sp, 184]
	str	w7, [x4, 4]
	str	s2, [x4]
	str	s1, [sp, 160]
	cmp	x1, x0
	bne	.L2656
.L2547:
	add	x3, sp, 140
	add	x2, sp, 160
	add	x0, sp, 176
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE209:
	ldr	x7, [sp, 184]
	ldr	w8, [sp, 140]
	ldr	w9, [x7, -4]
	ldr	s1, [x7, -8]
	b	.L2548
	.p2align 2,,3
.L2612:
	sub	x3, x2, #1
	ldr	w6, [x5, 4]
	str	s0, [x0, x1]
	mov	x1, x2
	add	x3, x3, x3, lsr 63
	str	w6, [x4, 4]
	asr	x2, x3, 1
	cmp	x1, 0
	bgt	.L2552
	mov	x4, x5
	b	.L2550
	.p2align 2,,3
.L2613:
	ldp	x2, x0, [x21]
	ldr	x1, [x19, 72]
	sub	x0, x0, x2
	cmp	x1, x0, asr 3
	beq	.L2655
.L2555:
	add	x0, sp, 176
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	ldr	x0, [x19, 192]
	mov	w1, 48
	strb	wzr, [sp, 168]
	uxtw	x25, w20
	umaddl	x0, w20, w1, x0
	str	x0, [sp, 160]
	cbz	x0, .L2657
	adrp	x1, .LC36
	ldr	x27, [x1, #:lo12:.LC36]
	cbz	x27, .L2559
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L2658
.L2559:
	mov	w0, 1
	strb	w0, [sp, 168]
	cbnz	w28, .L2560
	ldr	x1, [x19, 24]
	ldr	x0, [x19, 240]
	ldr	x24, [x19, 256]
	madd	x25, x25, x1, x0
	add	x24, x24, x25
	ldrh	w25, [x24]
	cbz	x25, .L2562
.L2662:
	mov	x20, 0
	b	.L2563
	.p2align 2,,3
.L2659:
	fcmpe	s0, s8
	bmi	.L2567
.L2566:
	cmp	x25, x20
	beq	.L2564
.L2563:
	add	x20, x20, 1
	ldr	w0, [x24, x20, lsl 2]
	str	w0, [sp, 148]
	uxtw	x1, w0
	ubfiz	x0, x0, 1, 32
	ldrh	w2, [x22, x0]
	cmp	w2, w23
	beq	.L2566
	ldr	x5, [x19, 24]
	ldr	x4, [x19, 232]
	ldp	x3, x2, [x19, 304]
	strh	w23, [x22, x0]
	madd	x1, x1, x5, x4
	mov	x0, x26
	ldr	x4, [x19, 256]
	add	x1, x4, x1
.LEHB210:
	blr	x3
.LEHE210:
	ldp	x0, x6, [x21]
	str	s0, [sp, 152]
	ldr	x1, [x19, 72]
	sub	x0, x6, x0
	cmp	x1, x0, asr 3
	bls	.L2659
.L2567:
	ldp	x1, x0, [sp, 184]
	fneg	s0, s0
	str	s0, [sp, 156]
	cmp	x1, x0
	beq	.L2570
	ldr	w7, [sp, 148]
	add	x0, x1, 8
	str	s0, [x1]
	mov	w8, w7
	str	w7, [x1, 4]
	str	x0, [sp, 184]
.L2571:
	ldr	x4, [sp, 176]
	sub	x3, x0, x4
	asr	x0, x3, 3
	sub	x2, x0, #2
	sub	x0, x0, #1
	add	x2, x2, x2, lsr 63
	asr	x2, x2, 1
	cmp	x0, 0
	ble	.L2572
	.p2align 3,,7
.L2575:
	lsl	x3, x2, 3
	lsl	x0, x0, 3
	add	x1, x4, x3
	add	x5, x4, x0
	ldr	s1, [x4, x3]
	fcmpe	s1, s0
	bmi	.L2614
.L2573:
	ldr	x3, [x19, 24]
	uxtw	x0, w7
	ldr	x2, [x19, 256]
	ldr	x1, [x19, 240]
	str	w8, [x5, 4]
	madd	x0, x0, x3, x2
	str	s0, [x5]
	add	x0, x0, x1
	ldrb	w0, [x0, 2]
	tbz	x0, 0, .L2576
	ldr	x2, [x21]
	sub	x9, x6, x2
	asr	x9, x9, 3
.L2577:
	ldr	x0, [x19, 72]
	cmp	x0, x9
	bcc	.L2660
.L2584:
	cmp	x2, x6
	beq	.L2566
	ldr	s8, [x2]
	cmp	x25, x20
	bne	.L2563
.L2564:
	ldrb	w0, [sp, 168]
	cbnz	w0, .L2562
.L2585:
	ldp	x0, x1, [sp, 176]
	cmp	x0, x1
	bne	.L2587
.L2557:
	ldr	x19, [x19, 112]
	strb	wzr, [sp, 168]
	add	x0, x19, 80
	str	x0, [sp, 160]
	cbz	x27, .L2588
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L2661
.L2588:
	ldp	x0, x1, [x19, 16]
	mov	w2, 1
	strb	w2, [sp, 168]
	cmp	x0, x1
	beq	.L2589
	ldr	x1, [sp, 128]
	str	x1, [x0, -8]!
	str	x0, [x19, 16]
.L2590:
	add	x0, sp, 160
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
.L2593:
	ldr	x0, [sp, 176]
	cbz	x0, .L2539
	bl	_ZdlPv
.L2539:
	mov	x0, x21
	ldr	d8, [sp, 96]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 208
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_restore 72
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L2614:
	.cfi_restore_state
	sub	x3, x2, #1
	ldr	w9, [x1, 4]
	str	s1, [x4, x0]
	mov	x0, x2
	add	x3, x3, x3, lsr 63
	str	w9, [x5, 4]
	asr	x2, x3, 1
	cmp	x0, 0
	bgt	.L2575
	mov	x5, x1
	b	.L2573
	.p2align 2,,3
.L2660:
	mov	x0, x21
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	ldp	x2, x6, [x21]
	b	.L2584
	.p2align 2,,3
.L2576:
	ldr	x0, [x21, 16]
	cmp	x0, x6
	beq	.L2578
	ldr	s1, [sp, 152]
	add	x6, x6, 8
	str	w7, [x6, -4]
	str	s1, [x6, -8]
	str	x6, [x21, 8]
.L2579:
	ldr	x2, [x21]
	sub	x3, x6, x2
	asr	x9, x3, 3
	sub	x0, x9, #2
	sub	x1, x9, #1
	add	x0, x0, x0, lsr 63
	asr	x0, x0, 1
	cmp	x1, 0
	ble	.L2580
	.p2align 3,,7
.L2583:
	lsl	x3, x0, 3
	lsl	x1, x1, 3
	add	x5, x2, x3
	add	x4, x2, x1
	ldr	s0, [x2, x3]
	fcmpe	s0, s1
	bmi	.L2615
	str	s1, [x4]
	str	w7, [x4, 4]
	b	.L2577
	.p2align 2,,3
.L2615:
	sub	x3, x0, #1
	ldr	w8, [x5, 4]
	str	s0, [x2, x1]
	mov	x1, x0
	add	x3, x3, x3, lsr 63
	str	w8, [x4, 4]
	asr	x0, x3, 1
	cmp	x1, 0
	bgt	.L2583
	mov	x4, x5
	str	s1, [x4]
	str	w7, [x4, 4]
	b	.L2577
	.p2align 2,,3
.L2570:
	add	x3, sp, 148
	add	x2, sp, 156
	add	x0, sp, 176
.LEHB211:
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	ldr	x0, [sp, 184]
	ldr	w7, [sp, 148]
	ldr	x6, [x21, 8]
	ldr	w8, [x0, -4]
	ldr	s0, [x0, -8]
	b	.L2571
	.p2align 2,,3
.L2560:
	ldr	x0, [x19, 264]
	ldr	x24, [x19, 32]
	ldr	x0, [x0, x25, lsl 3]
	ldr	x1, [sp, 120]
	madd	x24, x1, x24, x0
	ldrh	w25, [x24]
	cbnz	x25, .L2662
.L2562:
	ldr	x0, [sp, 160]
	cbz	x0, .L2585
	cbz	x27, .L2585
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
	b	.L2585
.L2578:
	mov	x1, x6
	add	x3, sp, 148
	add	x2, sp, 152
	mov	x0, x21
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE211:
	ldr	x6, [x21, 8]
	ldr	w7, [x6, -4]
	ldr	s1, [x6, -8]
	b	.L2579
.L2572:
	sub	x0, x3, #8
	add	x5, x4, x0
	b	.L2573
.L2580:
	sub	x3, x3, #8
	add	x4, x2, x3
	str	s1, [x4]
	str	w7, [x4, 4]
	b	.L2577
.L2655:
	adrp	x0, .LC36
	ldr	x27, [x0, #:lo12:.LC36]
	b	.L2557
.L2540:
	mvni	v0.2s, 0x80, lsl 16
	add	x2, sp, 140
	add	x1, sp, 160
	add	x0, sp, 176
	str	s0, [sp, 160]
.LEHB212:
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE7emplaceIJfRjEEEvDpOT_
.LEHE212:
	mov	w1, 2139095039
	ldr	w8, [sp, 140]
	fmov	s8, w1
	ldp	x0, x7, [sp, 176]
	b	.L2553
.L2589:
	add	x20, x19, 16
	mov	x5, 1152921504606846975
	ldp	x4, x6, [x19, 48]
	ldp	x3, x22, [x20, 16]
	ldr	x1, [x19, 72]
	sub	x4, x4, x6
	sub	x1, x1, x22
	sub	x3, x3, x0
	asr	x0, x4, 3
	asr	x1, x1, 3
	sub	x1, x1, #1
	add	x0, x0, x1, lsl 6
	add	x0, x0, x3, asr 3
	cmp	x0, x5
	beq	.L2663
	ldr	x0, [x19]
	cmp	x22, x0
	beq	.L2664
.L2592:
	mov	x0, 512
.LEHB213:
	bl	_Znwm
.LEHE213:
	ldrb	w1, [sp, 168]
	str	x0, [x22, -8]
	ldr	x0, [x19, 40]
	sub	x2, x0, #8
	ldr	x0, [x0, -8]
	str	x2, [x20, 24]
	str	x0, [x20, 8]
	add	x2, x0, 512
	str	x2, [x20, 16]
	add	x2, x0, 504
	str	x2, [x19, 16]
	ldr	x2, [sp, 128]
	str	x2, [x0, 504]
	cbz	w1, .L2593
	b	.L2590
	.p2align 2,,3
.L2541:
	add	x3, sp, 140
	add	x2, sp, 156
	mov	x0, x21
.LEHB214:
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE214:
	ldr	x0, [x21, 8]
	ldr	s8, [sp, 156]
	ldr	w7, [x0, -4]
	ldr	s2, [x0, -8]
	b	.L2542
.L2664:
	mov	x0, x19
	mov	x1, 1
.LEHB215:
	bl	_ZNSt5dequeIPN7hnswlib11VisitedListESaIS2_EE17_M_reallocate_mapEmb
.LEHE215:
	ldr	x22, [x19, 40]
	b	.L2592
.L2549:
	sub	x3, x3, #8
	add	x4, x0, x3
	b	.L2550
.L2543:
	sub	x0, x2, #8
	add	x4, x3, x0
	b	.L2544
.L2657:
	mov	w0, 1
.LEHB216:
	bl	_ZSt20__throw_system_errori
.L2661:
	bl	_ZSt20__throw_system_errori
	.p2align 2,,3
.L2658:
	bl	_ZSt20__throw_system_errori
.LEHE216:
.L2663:
	adrp	x0, .LC80
	add	x0, x0, :lo12:.LC80
.LEHB217:
	bl	_ZSt20__throw_length_errorPKc
.LEHE217:
.L2610:
	ldrb	w1, [sp, 168]
	mov	x19, x0
	cbz	w1, .L2598
	add	x0, sp, 160
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
	b	.L2598
.L2609:
	ldrb	w1, [sp, 168]
	mov	x19, x0
	cbz	w1, .L2598
	add	x0, sp, 160
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
.L2598:
	ldr	x0, [sp, 176]
	cbz	x0, .L2601
	bl	_ZdlPv
.L2601:
	ldr	x0, [x21]
	cbz	x0, .L2602
	bl	_ZdlPv
.L2602:
	mov	x0, x19
.LEHB218:
	bl	_Unwind_Resume
.LEHE218:
.L2608:
	mov	x19, x0
	b	.L2598
	.cfi_endproc
.LFE11871:
	.section	.gcc_except_table
.LLSDA11871:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE11871-.LLSDACSB11871
.LLSDACSB11871:
	.uleb128 .LEHB208-.LFB11871
	.uleb128 .LEHE208-.LEHB208
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB209-.LFB11871
	.uleb128 .LEHE209-.LEHB209
	.uleb128 .L2608-.LFB11871
	.uleb128 0
	.uleb128 .LEHB210-.LFB11871
	.uleb128 .LEHE210-.LEHB210
	.uleb128 .L2609-.LFB11871
	.uleb128 0
	.uleb128 .LEHB211-.LFB11871
	.uleb128 .LEHE211-.LEHB211
	.uleb128 .L2609-.LFB11871
	.uleb128 0
	.uleb128 .LEHB212-.LFB11871
	.uleb128 .LEHE212-.LEHB212
	.uleb128 .L2608-.LFB11871
	.uleb128 0
	.uleb128 .LEHB213-.LFB11871
	.uleb128 .LEHE213-.LEHB213
	.uleb128 .L2610-.LFB11871
	.uleb128 0
	.uleb128 .LEHB214-.LFB11871
	.uleb128 .LEHE214-.LEHB214
	.uleb128 .L2608-.LFB11871
	.uleb128 0
	.uleb128 .LEHB215-.LFB11871
	.uleb128 .LEHE215-.LEHB215
	.uleb128 .L2610-.LFB11871
	.uleb128 0
	.uleb128 .LEHB216-.LFB11871
	.uleb128 .LEHE216-.LEHB216
	.uleb128 .L2608-.LFB11871
	.uleb128 0
	.uleb128 .LEHB217-.LFB11871
	.uleb128 .LEHE217-.LEHB217
	.uleb128 .L2610-.LFB11871
	.uleb128 0
	.uleb128 .LEHB218-.LFB11871
	.uleb128 .LEHE218-.LEHB218
	.uleb128 0
	.uleb128 0
.LLSDACSE11871:
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE15searchBaseLayerEjPKvi,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE15searchBaseLayerEjPKvi,comdat
	.size	_ZN7hnswlib15HierarchicalNSWIfE15searchBaseLayerEjPKvi, .-_ZN7hnswlib15HierarchicalNSWIfE15searchBaseLayerEjPKvi
	.section	.rodata._ZN7hnswlib15HierarchicalNSWIfE26repairConnectionsForUpdateEPKvjjii.str1.8,"aMS",@progbits,1
	.align	3
.LC81:
	.string	"Level of item to be updated cannot be bigger than max level"
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE26repairConnectionsForUpdateEPKvjjii,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE26repairConnectionsForUpdateEPKvjjii,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib15HierarchicalNSWIfE26repairConnectionsForUpdateEPKvjjii
	.type	_ZN7hnswlib15HierarchicalNSWIfE26repairConnectionsForUpdateEPKvjjii, %function
_ZN7hnswlib15HierarchicalNSWIfE26repairConnectionsForUpdateEPKvjjii:
.LFB11924:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA11924
	stp	x29, x30, [sp, -208]!
	.cfi_def_cfa_offset 208
	.cfi_offset 29, -208
	.cfi_offset 30, -200
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -192
	.cfi_offset 20, -184
	mov	x19, x0
	stp	x21, x22, [sp, 32]
	stp	x23, x24, [sp, 48]
	.cfi_offset 21, -176
	.cfi_offset 22, -168
	.cfi_offset 23, -160
	.cfi_offset 24, -152
	mov	x23, x1
	mov	w24, w2
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -144
	.cfi_offset 26, -136
	mov	w26, w3
	stp	x27, x28, [sp, 80]
	str	d8, [sp, 96]
	.cfi_offset 27, -128
	.cfi_offset 28, -120
	.cfi_offset 72, -112
	stp	w5, w4, [sp, 116]
	str	w2, [sp, 124]
	cmp	w4, w5
	bge	.L2666
	mov	x0, x1
	uxtw	x21, w2
	ldr	x1, [x19, 24]
	add	x28, x19, 192
	ldr	x4, [x19, 232]
	ldp	x3, x2, [x19, 304]
	madd	x1, x21, x1, x4
	ldr	x4, [x19, 256]
	add	x1, x4, x1
.LEHB219:
	blr	x3
.LEHE219:
	fmov	s8, s0
.L2679:
	ldr	w0, [sp, 116]
	sub	w0, w0, #1
	sxtw	x0, w0
	mov	x27, x0
	.p2align 3,,7
.L2677:
	ldr	x0, [x28]
	mov	w1, 48
	strb	wzr, [sp, 184]
	umaddl	x0, w24, w1, x0
	str	x0, [sp, 176]
	cbz	x0, .L2762
	adrp	x1, .LC36
	add	x1, x1, :lo12:.LC36
	ldr	x1, [x1]
	cbz	x1, .L2668
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L2763
.L2668:
	mov	w0, 1
	strb	w0, [sp, 184]
	ldr	w0, [sp, 116]
	cbnz	w0, .L2669
	ldr	x0, [x19, 24]
	ldr	x1, [x19, 240]
	ldr	x20, [x19, 256]
	madd	x0, x21, x0, x1
	add	x20, x20, x0
	ldrh	w22, [x20]
	cbz	w22, .L2671
.L2766:
	sub	w22, w22, #1
	add	x0, x20, 8
	add	x20, x20, 4
	mov	w25, 0
	add	x22, x0, x22, uxtw 2
	.p2align 3,,7
.L2674:
	ldr	w21, [x20]
	mov	x0, x23
	ldr	x5, [x19, 24]
	uxtw	x1, w21
	ldr	x4, [x19, 232]
	ldp	x3, x2, [x19, 304]
	madd	x1, x1, x5, x4
	ldr	x4, [x19, 256]
	add	x1, x4, x1
.LEHB220:
	blr	x3
.LEHE220:
	fcmpe	s0, s8
	bmi	.L2718
.L2672:
	add	x20, x20, 4
	cmp	x22, x20
	bne	.L2674
	ldrb	w0, [sp, 184]
	cbnz	w0, .L2764
.L2675:
	cbz	w25, .L2709
.L2765:
	uxtw	x21, w24
	b	.L2677
	.p2align 2,,3
.L2764:
	ldr	x0, [sp, 176]
	cbz	x0, .L2675
.L2710:
	adrp	x1, .LC36
	add	x1, x1, :lo12:.LC36
	ldr	x1, [x1]
	cbz	x1, .L2675
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
	cbnz	w25, .L2765
.L2709:
	ldp	w0, w1, [sp, 116]
	sub	w0, w0, #1
	str	w0, [sp, 116]
	cmp	w1, w0
	beq	.L2678
	uxtw	x21, w24
	b	.L2679
	.p2align 2,,3
.L2718:
	fmov	s8, s0
	mov	w24, w21
	mov	w25, 1
	b	.L2672
	.p2align 2,,3
.L2669:
	ldr	x0, [x19, 264]
	ldr	x20, [x19, 32]
	ldr	x0, [x0, x21, lsl 3]
	madd	x20, x27, x20, x0
	ldrh	w22, [x20]
	cbnz	w22, .L2766
.L2671:
	ldr	x0, [sp, 176]
	cbz	x0, .L2709
	mov	w25, 0
	b	.L2710
.L2666:
	bgt	.L2680
.L2678:
	ldr	w0, [sp, 120]
	tbnz	w0, #31, .L2665
	.p2align 3,,7
.L2681:
	ldr	w3, [sp, 120]
	mov	x2, x23
	mov	x0, x19
	add	x8, sp, 144
	mov	w1, w24
.LEHB221:
	bl	_ZN7hnswlib15HierarchicalNSWIfE15searchBaseLayerEjPKvi
.LEHE221:
	stp	xzr, xzr, [sp, 176]
	ldp	x2, x0, [sp, 144]
	str	xzr, [sp, 192]
	cmp	x2, x0
	beq	.L2682
	.p2align 3,,7
.L2690:
	ldr	w0, [x2, 4]
	cmp	w0, w26
	beq	.L2683
	ldp	x1, x0, [sp, 184]
	cmp	x1, x0
	beq	.L2684
	ldr	x0, [x2]
	str	x0, [x1], 8
	str	x1, [sp, 184]
.L2685:
	ldr	x3, [sp, 176]
	ldr	w7, [x1, -4]
	sub	x2, x1, x3
	ldr	s1, [x1, -8]
	asr	x0, x2, 3
	sub	x1, x0, #2
	sub	x0, x0, #1
	add	x1, x1, x1, lsr 63
	asr	x1, x1, 1
	cmp	x0, 0
	ble	.L2686
	.p2align 3,,7
.L2689:
	lsl	x2, x1, 3
	lsl	x0, x0, 3
	add	x5, x3, x2
	add	x4, x3, x0
	ldr	s0, [x3, x2]
	fcmpe	s1, s0
	bgt	.L2719
.L2687:
	str	w7, [x4, 4]
	str	s1, [x4]
.L2683:
	add	x0, sp, 144
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	ldp	x2, x0, [sp, 144]
	cmp	x0, x2
	bne	.L2690
	ldp	x1, x0, [sp, 176]
	cmp	x0, x1
	beq	.L2691
	ldr	w2, [sp, 124]
	ldr	x0, [x19, 24]
	ldr	x3, [x19, 256]
	mul	x2, x2, x0
	ldr	x1, [x19, 240]
	add	x0, x3, x2
	add	x0, x0, x1
	ldrb	w0, [x0, 2]
	tbz	x0, 0, .L2693
	ldr	x1, [x19, 232]
	mov	x0, x23
	ldr	x4, [x19, 304]
	add	x1, x2, x1
	ldr	x2, [x19, 312]
	add	x1, x3, x1
.LEHB222:
	blr	x4
	ldp	x1, x0, [sp, 184]
	str	s0, [sp, 140]
	cmp	x1, x0
	beq	.L2694
	ldr	w8, [sp, 124]
	add	x0, x1, 8
	str	s0, [x1]
	str	w8, [x1, 4]
	str	x0, [sp, 184]
.L2695:
	ldr	x3, [sp, 176]
	sub	x2, x0, x3
	asr	x7, x2, 3
	sub	x0, x7, #2
	sub	x1, x7, #1
	add	x0, x0, x0, lsr 63
	asr	x0, x0, 1
	cmp	x1, 0
	ble	.L2696
	.p2align 3,,7
.L2699:
	lsl	x2, x0, 3
	lsl	x1, x1, 3
	add	x5, x3, x2
	add	x4, x3, x1
	ldr	s1, [x3, x2]
	fcmpe	s1, s0
	bmi	.L2720
.L2697:
	ldr	x0, [x19, 72]
	str	s0, [x4]
	str	w8, [x4, 4]
	cmp	x0, x7
	bcc	.L2767
.L2693:
	ldr	w3, [sp, 120]
	add	x2, sp, 176
	mov	w1, w26
	mov	x0, x19
	mov	w4, 1
	bl	_ZN7hnswlib15HierarchicalNSWIfE25mutuallyConnectNewElementEPKvjRSt14priority_queueISt4pairIfjESt6vectorIS6_SaIS6_EENS1_14CompareByFirstEEib.isra.0
	ldr	x1, [sp, 176]
	mov	w24, w0
.L2691:
	cbz	x1, .L2760
	mov	x0, x1
	bl	_ZdlPv
.L2760:
	ldr	x2, [sp, 144]
.L2682:
	cbz	x2, .L2701
	mov	x0, x2
	bl	_ZdlPv
.L2701:
	ldr	w0, [sp, 120]
	sub	w0, w0, #1
	str	w0, [sp, 120]
	cmn	w0, #1
	bne	.L2681
.L2665:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldr	d8, [sp, 96]
	ldp	x29, x30, [sp], 208
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_restore 72
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L2719:
	.cfi_restore_state
	sub	x2, x1, #1
	ldr	w6, [x5, 4]
	str	s0, [x3, x0]
	mov	x0, x1
	add	x2, x2, x2, lsr 63
	str	w6, [x4, 4]
	asr	x1, x2, 1
	cmp	x0, 0
	bgt	.L2689
	mov	x4, x5
	b	.L2687
	.p2align 2,,3
.L2720:
	sub	x2, x0, #1
	ldr	w6, [x5, 4]
	str	s1, [x3, x1]
	mov	x1, x0
	add	x2, x2, x2, lsr 63
	str	w6, [x4, 4]
	asr	x0, x2, 1
	cmp	x1, 0
	bgt	.L2699
	mov	x4, x5
	ldr	x0, [x19, 72]
	str	s0, [x4]
	str	w8, [x4, 4]
	cmp	x0, x7
	bcs	.L2693
.L2767:
	add	x0, sp, 176
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	b	.L2693
	.p2align 2,,3
.L2684:
	add	x0, sp, 176
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRKS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	ldr	x1, [sp, 184]
	b	.L2685
.L2686:
	sub	x2, x2, #8
	add	x4, x3, x2
	b	.L2687
.L2694:
	add	x3, sp, 124
	add	x2, sp, 140
	add	x0, sp, 176
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE222:
	ldr	x0, [sp, 184]
	ldr	w8, [x0, -4]
	ldr	s0, [x0, -8]
	b	.L2695
.L2696:
	sub	x0, x2, #8
	add	x4, x3, x0
	b	.L2697
.L2763:
.LEHB223:
	bl	_ZSt20__throw_system_errori
.L2762:
	mov	w0, 1
	bl	_ZSt20__throw_system_errori
.LEHE223:
.L2680:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC81
	mov	x19, x0
	add	x1, x1, :lo12:.LC81
.LEHB224:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE224:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x19
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB225:
	bl	__cxa_throw
.LEHE225:
.L2717:
	ldr	x1, [sp, 176]
	mov	x19, x0
	cbz	x1, .L2707
	mov	x0, x1
	bl	_ZdlPv
.L2707:
	ldr	x0, [sp, 144]
	cbz	x0, .L2761
	bl	_ZdlPv
	b	.L2761
.L2715:
	ldrb	w1, [sp, 184]
	mov	x19, x0
	cbz	w1, .L2761
	add	x0, sp, 176
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
	b	.L2761
.L2716:
	mov	x1, x0
	mov	x0, x19
	mov	x19, x1
	bl	__cxa_free_exception
.L2761:
	mov	x0, x19
.LEHB226:
	bl	_Unwind_Resume
.LEHE226:
	.cfi_endproc
.LFE11924:
	.section	.gcc_except_table
.LLSDA11924:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE11924-.LLSDACSB11924
.LLSDACSB11924:
	.uleb128 .LEHB219-.LFB11924
	.uleb128 .LEHE219-.LEHB219
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB220-.LFB11924
	.uleb128 .LEHE220-.LEHB220
	.uleb128 .L2715-.LFB11924
	.uleb128 0
	.uleb128 .LEHB221-.LFB11924
	.uleb128 .LEHE221-.LEHB221
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB222-.LFB11924
	.uleb128 .LEHE222-.LEHB222
	.uleb128 .L2717-.LFB11924
	.uleb128 0
	.uleb128 .LEHB223-.LFB11924
	.uleb128 .LEHE223-.LEHB223
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB224-.LFB11924
	.uleb128 .LEHE224-.LEHB224
	.uleb128 .L2716-.LFB11924
	.uleb128 0
	.uleb128 .LEHB225-.LFB11924
	.uleb128 .LEHE225-.LEHB225
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB226-.LFB11924
	.uleb128 .LEHE226-.LEHB226
	.uleb128 0
	.uleb128 0
.LLSDACSE11924:
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE26repairConnectionsForUpdateEPKvjjii,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE26repairConnectionsForUpdateEPKvjjii,comdat
	.size	_ZN7hnswlib15HierarchicalNSWIfE26repairConnectionsForUpdateEPKvjjii, .-_ZN7hnswlib15HierarchicalNSWIfE26repairConnectionsForUpdateEPKvjjii
	.section	.text._ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_rehashEmRKm,"axG",@progbits,_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_rehashEmRKm,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_rehashEmRKm
	.type	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_rehashEmRKm, %function
_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_rehashEmRKm:
.LFB12665:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA12665
	stp	x29, x30, [sp, -48]!
	.cfi_def_cfa_offset 48
	.cfi_offset 29, -48
	.cfi_offset 30, -40
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -32
	.cfi_offset 20, -24
	mov	x19, x1
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -16
	.cfi_offset 22, -8
	mov	x21, x0
	cmp	x1, 1
	beq	.L2790
	mov	x20, x2
	mov	x0, 1152921504606846975
	cmp	x1, x0
	bhi	.L2791
	lsl	x22, x1, 3
	mov	x0, x22
.LEHB227:
	bl	_Znwm
	mov	x20, x0
	mov	x2, x22
	mov	w1, 0
	bl	memset
	add	x8, x21, 48
.L2770:
	ldr	x4, [x21, 16]
	str	xzr, [x21, 16]
	cbz	x4, .L2772
	add	x7, x21, 16
	mov	x6, 0
	.p2align 3,,7
.L2773:
	ldr	w5, [x4, 8]
	mov	x3, x4
	ldr	x4, [x4]
	udiv	x2, x5, x19
	msub	x2, x2, x19, x5
	ldr	x1, [x20, x2, lsl 3]
	cbz	x1, .L2792
	ldr	x0, [x1]
	str	x0, [x3]
	ldr	x0, [x20, x2, lsl 3]
	str	x3, [x0]
	cbnz	x4, .L2773
.L2772:
	ldr	x0, [x21]
	cmp	x0, x8
	beq	.L2776
	bl	_ZdlPv
.L2776:
	stp	x20, x19, [x21]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 48
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L2792:
	.cfi_restore_state
	ldr	x0, [x21, 16]
	str	x0, [x3]
	str	x3, [x21, 16]
	str	x7, [x20, x2, lsl 3]
	ldr	x0, [x3]
	cbz	x0, .L2779
	str	x3, [x20, x6, lsl 3]
	mov	x6, x2
	cbnz	x4, .L2773
	b	.L2772
	.p2align 2,,3
.L2779:
	mov	x6, x2
	cbnz	x4, .L2773
	b	.L2772
	.p2align 2,,3
.L2790:
	mov	x20, x0
	str	xzr, [x20, 48]!
	mov	x8, x20
	b	.L2770
.L2791:
	bl	_ZSt17__throw_bad_allocv
.LEHE227:
.L2780:
	bl	__cxa_begin_catch
	ldr	x0, [x20]
	str	x0, [x21, 40]
.LEHB228:
	bl	__cxa_rethrow
.LEHE228:
.L2781:
	mov	x19, x0
	bl	__cxa_end_catch
	mov	x0, x19
.LEHB229:
	bl	_Unwind_Resume
.LEHE229:
	.cfi_endproc
.LFE12665:
	.section	.gcc_except_table
	.align	2
.LLSDA12665:
	.byte	0xff
	.byte	0x9b
	.uleb128 .LLSDATT12665-.LLSDATTD12665
.LLSDATTD12665:
	.byte	0x1
	.uleb128 .LLSDACSE12665-.LLSDACSB12665
.LLSDACSB12665:
	.uleb128 .LEHB227-.LFB12665
	.uleb128 .LEHE227-.LEHB227
	.uleb128 .L2780-.LFB12665
	.uleb128 0x1
	.uleb128 .LEHB228-.LFB12665
	.uleb128 .LEHE228-.LEHB228
	.uleb128 .L2781-.LFB12665
	.uleb128 0
	.uleb128 .LEHB229-.LFB12665
	.uleb128 .LEHE229-.LEHB229
	.uleb128 0
	.uleb128 0
.LLSDACSE12665:
	.byte	0x1
	.byte	0
	.align	2
	.4byte	0

.LLSDATT12665:
	.section	.text._ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_rehashEmRKm,"axG",@progbits,_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_rehashEmRKm,comdat
	.size	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_rehashEmRKm, .-_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_rehashEmRKm
	.section	.text._ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_insertIRKjNS1_10_AllocNodeISaINS1_10_Hash_nodeIjLb0EEEEEEEESt4pairINS1_14_Node_iteratorIjLb1ELb0EEEbEOT_RKT0_St17integral_constantIbLb1EEm.isra.0,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE11updatePointEPKvjf,comdat
	.align	2
	.p2align 4,,11
	.type	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_insertIRKjNS1_10_AllocNodeISaINS1_10_Hash_nodeIjLb0EEEEEEEESt4pairINS1_14_Node_iteratorIjLb1ELb0EEEbEOT_RKT0_St17integral_constantIbLb1EEm.isra.0, %function
_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_insertIRKjNS1_10_AllocNodeISaINS1_10_Hash_nodeIjLb0EEEEEEEESt4pairINS1_14_Node_iteratorIjLb1ELb0EEEbEOT_RKT0_St17integral_constantIbLb1EEm.isra.0:
.LFB13089:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA13089
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	mov	x24, x1
	ldr	w1, [x1]
	ldr	x7, [x0, 8]
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	uxtw	x20, w1
	mov	x19, x0
	str	x25, [sp, 64]
	.cfi_offset 25, -32
	mov	x25, x2
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	ldr	x2, [x0]
	udiv	x0, x20, x7
	msub	x0, x0, x7, x20
	lsl	x22, x0, 3
	ldr	x8, [x2, x0, lsl 3]
	cbz	x8, .L2794
	ldr	x4, [x8]
	ldr	w5, [x4, 8]
	cmp	w1, w5
	beq	.L2795
.L2819:
	ldr	x6, [x4]
	cbz	x6, .L2794
	ldr	w5, [x6, 8]
	mov	x8, x4
	uxtw	x9, w5
	udiv	x4, x9, x7
	msub	x4, x4, x7, x9
	cmp	x0, x4
	bne	.L2794
	mov	x4, x6
	cmp	w1, w5
	bne	.L2819
.L2795:
	ldr	x0, [x8]
	mov	x21, 0
	cbz	x0, .L2794
	mov	x1, x21
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 96
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 25
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L2794:
	.cfi_restore_state
	mov	x0, 16
.LEHB230:
	bl	_Znwm
.LEHE230:
	ldr	w4, [x24]
	mov	x23, x0
	ldr	x1, [x19, 8]
	mov	x3, x25
	ldr	x2, [x19, 24]
	add	x0, x19, 32
	ldr	x5, [x19, 40]
	str	xzr, [x23]
	str	w4, [x23, 8]
	str	x5, [sp, 88]
.LEHB231:
	bl	_ZNKSt8__detail20_Prime_rehash_policy14_M_need_rehashEmmm
	tst	w0, 255
	bne	.L2820
	ldr	x0, [x19]
	add	x2, x0, x22
	ldr	x1, [x0, x22]
	cbz	x1, .L2799
.L2821:
	ldr	x1, [x1]
	str	x1, [x23]
	ldr	x0, [x0, x22]
	str	x23, [x0]
.L2800:
	ldr	x1, [x19, 24]
	mov	x2, 1
	bfi	x21, x2, 0, 8
	mov	x0, x23
	add	x1, x1, x2
	str	x1, [x19, 24]
	mov	x1, x21
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldr	x25, [sp, 64]
	ldp	x29, x30, [sp], 96
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 25
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L2820:
	.cfi_restore_state
	add	x2, sp, 88
	mov	x0, x19
	bl	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_rehashEmRKm
.LEHE231:
	ldr	x0, [x19, 8]
	udiv	x22, x20, x0
	msub	x22, x22, x0, x20
	ldr	x0, [x19]
	lsl	x22, x22, 3
	add	x2, x0, x22
	ldr	x1, [x0, x22]
	cbnz	x1, .L2821
.L2799:
	ldr	x1, [x19, 16]
	str	x1, [x23]
	str	x23, [x19, 16]
	cbz	x1, .L2801
	ldr	w4, [x1, 8]
	ldr	x3, [x19, 8]
	udiv	x1, x4, x3
	msub	x1, x1, x3, x4
	str	x23, [x0, x1, lsl 3]
.L2801:
	add	x0, x19, 16
	str	x0, [x2]
	b	.L2800
.L2804:
	mov	x19, x0
	mov	x0, x23
	bl	_ZdlPv
	mov	x0, x19
.LEHB232:
	bl	_Unwind_Resume
.LEHE232:
	.cfi_endproc
.LFE13089:
	.section	.gcc_except_table
.LLSDA13089:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE13089-.LLSDACSB13089
.LLSDACSB13089:
	.uleb128 .LEHB230-.LFB13089
	.uleb128 .LEHE230-.LEHB230
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB231-.LFB13089
	.uleb128 .LEHE231-.LEHB231
	.uleb128 .L2804-.LFB13089
	.uleb128 0
	.uleb128 .LEHB232-.LFB13089
	.uleb128 .LEHE232-.LEHB232
	.uleb128 0
	.uleb128 0
.LLSDACSE13089:
	.section	.text._ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_insertIRKjNS1_10_AllocNodeISaINS1_10_Hash_nodeIjLb0EEEEEEEESt4pairINS1_14_Node_iteratorIjLb1ELb0EEEbEOT_RKT0_St17integral_constantIbLb1EEm.isra.0,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE11updatePointEPKvjf,comdat
	.size	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_insertIRKjNS1_10_AllocNodeISaINS1_10_Hash_nodeIjLb0EEEEEEEESt4pairINS1_14_Node_iteratorIjLb1ELb0EEEbEOT_RKT0_St17integral_constantIbLb1EEm.isra.0, .-_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_insertIRKjNS1_10_AllocNodeISaINS1_10_Hash_nodeIjLb0EEEEEEEESt4pairINS1_14_Node_iteratorIjLb1ELb0EEEbEOT_RKT0_St17integral_constantIbLb1EEm.isra.0
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE11updatePointEPKvjf,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE11updatePointEPKvjf,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib15HierarchicalNSWIfE11updatePointEPKvjf
	.type	_ZN7hnswlib15HierarchicalNSWIfE11updatePointEPKvjf, %function
_ZN7hnswlib15HierarchicalNSWIfE11updatePointEPKvjf:
.LFB11506:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA11506
	stp	x29, x30, [sp, -336]!
	.cfi_def_cfa_offset 336
	.cfi_offset 29, -336
	.cfi_offset 30, -328
	uxtw	x3, w2
	mov	x29, sp
	ldr	x5, [x0, 24]
	stp	d8, d9, [sp, 96]
	.cfi_offset 72, -240
	.cfi_offset 73, -232
	fmov	s8, s0
	ldr	x4, [x0, 232]
	str	w2, [sp, 156]
	ldr	x2, [x0, 296]
	stp	x19, x20, [sp, 16]
	madd	x3, x3, x5, x4
	.cfi_offset 19, -320
	.cfi_offset 20, -312
	mov	x19, x0
	str	x1, [sp, 144]
	ldr	x0, [x0, 256]
	add	x0, x0, x3
	bl	memcpy
	ldr	w2, [x19, 104]
	ldr	w0, [x19, 216]
	ldr	w1, [sp, 156]
	str	w2, [sp, 140]
	str	w0, [sp, 152]
	cmp	w1, w0
	beq	.L2945
	stp	x25, x26, [sp, 64]
	.cfi_offset 26, -264
	.cfi_offset 25, -272
.L2823:
	ldr	x0, [x19, 272]
	ldr	w25, [x0, w1, uxtw 2]
	tbnz	w25, #31, .L2825
	movi	v9.2s, 0x30, lsl 24
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -296
	.cfi_offset 21, -304
	stp	x23, x24, [sp, 48]
	.cfi_offset 24, -280
	.cfi_offset 23, -288
	mov	x24, 0
	stp	x27, x28, [sp, 80]
	.cfi_offset 28, -248
	.cfi_offset 27, -256
	str	d10, [sp, 112]
	.cfi_offset 74, -224
	.p2align 3,,7
.L2829:
	add	x5, sp, 272
	add	x4, sp, 328
	fmov	s0, 1.0e+0
	mov	x3, 1
	mov	w28, w24
	add	x8, sp, 168
	mov	w2, w24
	mov	x0, x19
	stp	x5, x3, [sp, 224]
	stp	xzr, xzr, [sp, 240]
	str	s0, [sp, 256]
	stp	xzr, xzr, [sp, 264]
	stp	x4, x3, [sp, 280]
	stp	xzr, xzr, [sp, 296]
	str	s0, [sp, 312]
	stp	xzr, xzr, [sp, 320]
.LEHB233:
	bl	_ZN7hnswlib15HierarchicalNSWIfE22getConnectionsWithLockEji
.LEHE233:
	ldp	x0, x1, [sp, 168]
	cmp	x0, x1
	bne	.L2826
	cbz	x0, .L2828
.L2940:
	bl	_ZdlPv
.L2828:
	add	x0, sp, 280
	bl	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEED1Ev
	add	x0, sp, 224
	add	x24, x24, 1
	bl	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEED1Ev
	ldr	w1, [sp, 156]
	cmp	w25, w24
	bge	.L2829
	ldp	x21, x22, [sp, 32]
	.cfi_restore 22
	.cfi_restore 21
	ldp	x23, x24, [sp, 48]
	.cfi_restore 24
	.cfi_restore 23
	ldp	x27, x28, [sp, 80]
	.cfi_restore 28
	.cfi_restore 27
	ldr	d10, [sp, 112]
	.cfi_restore 74
.L2825:
	mov	w3, w1
	ldr	w5, [sp, 140]
	ldr	w2, [sp, 152]
	mov	w4, w25
	ldr	x1, [sp, 144]
	mov	x0, x19
.LEHB234:
	bl	_ZN7hnswlib15HierarchicalNSWIfE26repairConnectionsForUpdateEPKvjjii
.LEHE234:
	ldp	x25, x26, [sp, 64]
	.cfi_restore 26
	.cfi_restore 25
.L2822:
	ldp	x19, x20, [sp, 16]
	ldp	d8, d9, [sp, 96]
	ldp	x29, x30, [sp], 336
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_restore 72
	.cfi_restore 73
	.cfi_def_cfa_offset 0
	ret
.L2826:
	.cfi_def_cfa_offset 336
	.cfi_offset 19, -320
	.cfi_offset 20, -312
	.cfi_offset 21, -304
	.cfi_offset 22, -296
	.cfi_offset 23, -288
	.cfi_offset 24, -280
	.cfi_offset 25, -272
	.cfi_offset 26, -264
	.cfi_offset 27, -256
	.cfi_offset 28, -248
	.cfi_offset 29, -336
	.cfi_offset 30, -328
	.cfi_offset 72, -240
	.cfi_offset 73, -232
	.cfi_offset 74, -224
	add	x1, sp, 156
	add	x0, sp, 224
	mov	x2, 1
.LEHB235:
	bl	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_insertIRKjNS1_10_AllocNodeISaINS1_10_Hash_nodeIjLb0EEEEEEEESt4pairINS1_14_Node_iteratorIjLb1ELb0EEEbEOT_RKT0_St17integral_constantIbLb1EEm.isra.0
	ldp	x21, x23, [sp, 168]
	cmp	x23, x21
	beq	.L2841
	mov	x27, 5
	mov	w0, 1065353215
	movk	x27, 0x2, lsl 32
	fmov	s10, w0
	.p2align 3,,7
.L2840:
	mov	x1, x21
	add	x0, sp, 224
	mov	x2, 1
	bl	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_insertIRKjNS1_10_AllocNodeISaINS1_10_Hash_nodeIjLb0EEEEEEEESt4pairINS1_14_Node_iteratorIjLb1ELb0EEEbEOT_RKT0_St17integral_constantIbLb1EEm.isra.0
	ldr	x1, [x19, 432]
	mov	x0, 16807
	movi	v1.2s, #0
	fmov	s2, 1.0e+0
	mul	x1, x1, x0
	umulh	x2, x1, x27
	sub	x0, x1, x2
	add	x0, x2, x0, lsr 1
	lsr	x0, x0, 30
	lsl	x2, x0, 31
	sub	x0, x2, x0
	sub	x0, x1, x0
	str	x0, [x19, 432]
	sub	x0, x0, #1
	ucvtf	s0, x0
	fadd	s0, s0, s1
	fmul	s0, s0, s9
	fcmpe	s0, s2
	bge	.L2885
	fadd	s0, s0, s1
.L2833:
	fcmpe	s8, s0
	bmi	.L2836
	mov	x1, x21
	add	x0, sp, 280
	mov	x2, 1
	bl	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_insertIRKjNS1_10_AllocNodeISaINS1_10_Hash_nodeIjLb0EEEEEEEESt4pairINS1_14_Node_iteratorIjLb1ELb0EEEbEOT_RKT0_St17integral_constantIbLb1EEm.isra.0
	ldr	w1, [x21]
	add	x8, sp, 192
	mov	w2, w28
	mov	x0, x19
	bl	_ZN7hnswlib15HierarchicalNSWIfE22getConnectionsWithLockEji
.LEHE235:
	ldp	x0, x22, [sp, 192]
	cmp	x22, x0
	beq	.L2837
	mov	x20, x0
	.p2align 3,,7
.L2838:
	mov	x1, x20
	add	x0, sp, 224
	mov	x2, 1
.LEHB236:
	bl	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE9_M_insertIRKjNS1_10_AllocNodeISaINS1_10_Hash_nodeIjLb0EEEEEEEESt4pairINS1_14_Node_iteratorIjLb1ELb0EEEbEOT_RKT0_St17integral_constantIbLb1EEm.isra.0
.LEHE236:
	add	x20, x20, 4
	cmp	x22, x20
	bne	.L2838
	ldr	x0, [sp, 192]
.L2837:
	cbz	x0, .L2836
	bl	_ZdlPv
	.p2align 3,,7
.L2836:
	add	x21, x21, 4
	cmp	x23, x21
	bne	.L2840
.L2841:
	ldr	x21, [sp, 296]
	cbz	x21, .L2832
	sub	x28, x24, #1
	.p2align 3,,7
.L2831:
	ldp	x2, x4, [sp, 224]
	ldr	w0, [x21, 8]
	uxtw	x1, w0
	udiv	x5, x1, x4
	msub	x5, x5, x4, x1
	ldr	x6, [x2, x5, lsl 3]
	stp	xzr, xzr, [sp, 192]
	str	xzr, [sp, 208]
	cbz	x6, .L2941
	ldr	x1, [x6]
	ldr	w2, [x1, 8]
	cmp	w2, w0
	beq	.L2845
.L2946:
	ldr	x3, [x1]
	cbz	x3, .L2941
	ldr	w2, [x3, 8]
	mov	x6, x1
	uxtw	x7, w2
	udiv	x1, x7, x4
	msub	x1, x1, x4, x7
	cmp	x5, x1
	bne	.L2941
	mov	x1, x3
	cmp	w2, w0
	bne	.L2946
.L2845:
	ldr	x2, [x6]
	ldr	x1, [sp, 248]
	sub	x22, x1, #1
	cbz	x2, .L2844
.L2847:
	ldr	x1, [x19, 72]
	ldr	x20, [sp, 240]
	cmp	x1, x22
	csel	x22, x1, x22, ls
	cbnz	x20, .L2866
	b	.L2848
	.p2align 2,,3
.L2851:
	ldr	s1, [x3]
	fcmpe	s1, s0
	bgt	.L2893
.L2858:
	ldr	x20, [x20]
	cbz	x20, .L2848
.L2850:
	ldr	w0, [x21, 8]
.L2866:
	ldr	w1, [x20, 8]
	add	x23, x20, 8
	cmp	w1, w0
	beq	.L2858
	ldr	x5, [x19, 24]
	uxtw	x1, w1
	ldr	x4, [x19, 232]
	uxtw	x0, w0
	ldp	x6, x2, [x19, 304]
	ldr	x3, [x19, 256]
	madd	x1, x1, x5, x4
	madd	x0, x0, x5, x4
	add	x1, x3, x1
	add	x0, x3, x0
.LEHB237:
	blr	x6
	ldp	x3, x1, [sp, 192]
	str	s0, [sp, 164]
	sub	x0, x1, x3
	cmp	x22, x0, asr 3
	bls	.L2851
	ldr	x0, [sp, 208]
	cmp	x1, x0
	beq	.L2852
	add	x0, x1, 8
	ldr	w7, [x20, 8]
	sub	x2, x0, x3
	str	s0, [x1]
	str	w7, [x1, 4]
	str	x0, [sp, 200]
	asr	x0, x2, 3
	sub	x1, x0, #2
	sub	x0, x0, #1
	add	x1, x1, x1, lsr 63
	asr	x1, x1, 1
	cmp	x0, 0
	ble	.L2854
	.p2align 3,,7
.L2857:
	lsl	x2, x1, 3
	lsl	x0, x0, 3
	add	x5, x3, x2
	add	x4, x3, x0
	ldr	s1, [x3, x2]
	fcmpe	s1, s0
	bmi	.L2892
	str	w7, [x4, 4]
	str	s0, [x4]
.L2949:
	ldr	x20, [x20]
	cbnz	x20, .L2850
.L2848:
	ldp	x3, x2, [x19, 56]
	cmp	x24, 0
	add	x1, sp, 192
	mov	x0, x19
	csel	x2, x3, x2, ne
	bl	_ZN7hnswlib15HierarchicalNSWIfE24getNeighborsByHeuristic2ERSt14priority_queueISt4pairIfjESt6vectorIS4_SaIS4_EENS1_14CompareByFirstEEm
	ldr	w23, [x21, 8]
	mov	w2, 48
	ldr	x1, [x19, 192]
	uxtw	x0, w23
	umaddl	x23, w23, w2, x1
	cbz	x23, .L2947
	adrp	x1, .LC36
	ldr	x27, [x1, #:lo12:.LC36]
	cbz	x27, .L2869
	mov	x0, x23
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L2870
	ldr	w0, [x21, 8]
.L2869:
	cbnz	x24, .L2871
	ldr	x2, [x19, 24]
	ldr	x1, [x19, 240]
	ldr	x22, [x19, 256]
	madd	x0, x0, x2, x1
	add	x22, x22, x0
.L2872:
	ldp	x0, x20, [sp, 192]
	sub	x20, x20, x0
	asr	x20, x20, 3
	strh	w20, [x22]
	cbz	x20, .L2873
	mov	x26, 0
	b	.L2874
	.p2align 2,,3
.L2948:
	ldr	x0, [sp, 192]
.L2874:
	add	x26, x26, 1
	ldr	w2, [x0, 4]
	add	x0, sp, 192
	str	w2, [x22, x26, lsl 2]
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	cmp	x20, x26
	bne	.L2948
.L2873:
	cbz	x27, .L2875
	mov	x0, x23
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
.L2875:
	ldr	x0, [sp, 192]
	cbz	x0, .L2876
	bl	_ZdlPv
.L2876:
	ldr	x21, [x21]
	cbnz	x21, .L2831
.L2832:
	ldr	x0, [sp, 168]
	cbnz	x0, .L2940
	b	.L2828
	.p2align 2,,3
.L2892:
	sub	x2, x1, #1
	ldr	w6, [x5, 4]
	str	s1, [x3, x0]
	mov	x0, x1
	add	x2, x2, x2, lsr 63
	str	w6, [x4, 4]
	asr	x1, x2, 1
	cmp	x0, 0
	bgt	.L2857
	mov	x4, x5
	str	s0, [x4]
	str	w7, [x4, 4]
	b	.L2949
	.p2align 2,,3
.L2893:
	add	x0, sp, 192
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	ldp	x1, x0, [sp, 200]
	cmp	x1, x0
	beq	.L2860
	ldr	s1, [sp, 164]
	add	x0, x1, 8
	ldr	w7, [x20, 8]
	str	w7, [x1, 4]
	str	s1, [x1]
	str	x0, [sp, 200]
.L2861:
	ldr	x3, [sp, 192]
	sub	x2, x0, x3
	asr	x0, x2, 3
	sub	x1, x0, #2
	sub	x0, x0, #1
	add	x1, x1, x1, lsr 63
	asr	x1, x1, 1
	cmp	x0, 0
	ble	.L2862
	.p2align 3,,7
.L2865:
	lsl	x2, x1, 3
	lsl	x0, x0, 3
	add	x5, x3, x2
	add	x4, x3, x0
	ldr	s0, [x3, x2]
	fcmpe	s0, s1
	bmi	.L2894
	str	s1, [x4]
	str	w7, [x4, 4]
	b	.L2858
	.p2align 2,,3
.L2894:
	sub	x2, x1, #1
	ldr	w6, [x5, 4]
	str	s0, [x3, x0]
	mov	x0, x1
	add	x2, x2, x2, lsr 63
	str	w6, [x4, 4]
	asr	x1, x2, 1
	cmp	x0, 0
	bgt	.L2865
	mov	x4, x5
	str	s1, [x4]
	str	w7, [x4, 4]
	b	.L2858
	.p2align 2,,3
.L2871:
	ldr	x1, [x19, 264]
	ldr	x22, [x19, 32]
	ldr	x0, [x1, x0, lsl 3]
	madd	x22, x28, x22, x0
	b	.L2872
.L2941:
	ldr	x1, [sp, 248]
.L2844:
	mov	x22, x1
	b	.L2847
	.p2align 2,,3
.L2852:
	mov	x3, x23
	add	x2, sp, 164
	add	x0, sp, 192
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRKjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	ldp	x3, x0, [sp, 192]
	sub	x2, x0, x3
	ldr	w7, [x0, -4]
	ldr	s0, [x0, -8]
	asr	x0, x2, 3
	sub	x1, x0, #2
	sub	x0, x0, #1
	add	x1, x1, x1, lsr 63
	asr	x1, x1, 1
	cmp	x0, 0
	bgt	.L2857
.L2854:
	sub	x0, x2, #8
	add	x4, x3, x0
	str	s0, [x4]
	str	w7, [x4, 4]
	b	.L2949
	.p2align 2,,3
.L2860:
	mov	x3, x23
	add	x2, sp, 164
	add	x0, sp, 192
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRKjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	ldr	x0, [sp, 200]
	ldr	w7, [x0, -4]
	ldr	s1, [x0, -8]
	b	.L2861
.L2885:
	fmov	s0, s10
	b	.L2833
.L2862:
	sub	x0, x2, #8
	add	x4, x3, x0
	str	s1, [x4]
	str	w7, [x4, 4]
	b	.L2858
.L2945:
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 74
	add	x0, x19, 16
	ldar	x0, [x0]
	cmp	x0, 1
	beq	.L2822
	ldr	w1, [sp, 156]
	stp	x25, x26, [sp, 64]
	.cfi_offset 26, -264
	.cfi_offset 25, -272
	b	.L2823
.L2947:
	.cfi_offset 21, -304
	.cfi_offset 22, -296
	.cfi_offset 23, -288
	.cfi_offset 24, -280
	.cfi_offset 27, -256
	.cfi_offset 28, -248
	.cfi_offset 74, -224
	mov	w0, 1
	bl	_ZSt20__throw_system_errori
.L2870:
	bl	_ZSt20__throw_system_errori
.LEHE237:
.L2891:
.L2944:
	ldr	x1, [sp, 192]
	mov	x19, x0
	cbz	x1, .L2879
	mov	x0, x1
	bl	_ZdlPv
.L2879:
	ldr	x0, [sp, 168]
	cbz	x0, .L2883
	bl	_ZdlPv
.L2883:
	add	x0, sp, 280
	bl	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEED1Ev
	add	x0, sp, 224
	bl	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEED1Ev
	mov	x0, x19
.LEHB238:
	bl	_Unwind_Resume
.LEHE238:
.L2888:
	mov	x19, x0
	b	.L2883
.L2890:
	b	.L2944
.L2889:
	mov	x19, x0
	b	.L2879
	.cfi_endproc
.LFE11506:
	.section	.gcc_except_table
.LLSDA11506:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE11506-.LLSDACSB11506
.LLSDACSB11506:
	.uleb128 .LEHB233-.LFB11506
	.uleb128 .LEHE233-.LEHB233
	.uleb128 .L2888-.LFB11506
	.uleb128 0
	.uleb128 .LEHB234-.LFB11506
	.uleb128 .LEHE234-.LEHB234
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB235-.LFB11506
	.uleb128 .LEHE235-.LEHB235
	.uleb128 .L2889-.LFB11506
	.uleb128 0
	.uleb128 .LEHB236-.LFB11506
	.uleb128 .LEHE236-.LEHB236
	.uleb128 .L2890-.LFB11506
	.uleb128 0
	.uleb128 .LEHB237-.LFB11506
	.uleb128 .LEHE237-.LEHB237
	.uleb128 .L2891-.LFB11506
	.uleb128 0
	.uleb128 .LEHB238-.LFB11506
	.uleb128 .LEHE238-.LEHB238
	.uleb128 0
	.uleb128 0
.LLSDACSE11506:
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE11updatePointEPKvjf,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE11updatePointEPKvjf,comdat
	.size	_ZN7hnswlib15HierarchicalNSWIfE11updatePointEPKvjf, .-_ZN7hnswlib15HierarchicalNSWIfE11updatePointEPKvjf
	.section	.rodata._ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmi.str1.8,"aMS",@progbits,1
	.align	3
.LC82:
	.string	"Can't use addPoint to update deleted elements if replacement of deleted elements is enabled."
	.align	3
.LC83:
	.string	"The number of elements exceeds the specified limit"
	.align	3
.LC84:
	.string	"Not enough memory: addPoint failed to allocate linklist"
	.align	3
.LC85:
	.string	"cand error"
	.align	3
.LC86:
	.string	"Level error"
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmi,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmi,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmi
	.type	_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmi, %function
_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmi:
.LFB11490:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA11490
	stp	x29, x30, [sp, -240]!
	.cfi_def_cfa_offset 240
	.cfi_offset 29, -240
	.cfi_offset 30, -232
	adrp	x4, .LC36
	mov	x29, sp
	str	x2, [sp, 152]
	ldr	x2, [x4, #:lo12:.LC36]
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -224
	.cfi_offset 20, -216
	mov	x19, x0
	add	x0, x0, 320
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -192
	.cfi_offset 24, -184
	mov	x23, x1
	stp	x27, x28, [sp, 80]
	str	x2, [sp, 112]
	str	w3, [sp, 136]
	str	x0, [sp, 208]
	strb	wzr, [sp, 216]
	.cfi_offset 27, -160
	.cfi_offset 28, -152
	cbz	x2, .L2951
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L3094
.L2951:
	ldr	x6, [sp, 152]
	mov	w1, 1
	ldr	x4, [x19, 376]
	strb	w1, [sp, 216]
	ldr	x1, [x19, 368]
	stp	x25, x26, [sp, 64]
	.cfi_offset 26, -168
	.cfi_offset 25, -176
	add	x0, x19, 368
	udiv	x5, x6, x4
	msub	x5, x5, x4, x6
	ldr	x7, [x1, x5, lsl 3]
	cbz	x7, .L2952
	ldr	x2, [x7]
	ldr	x1, [x2, 8]
	cmp	x6, x1
	beq	.L2953
.L3095:
	ldr	x3, [x2]
	cbz	x3, .L2952
	ldr	x1, [x3, 8]
	mov	x7, x2
	udiv	x2, x1, x4
	msub	x2, x2, x4, x1
	cmp	x5, x2
	bne	.L2952
	mov	x2, x3
	cmp	x6, x1
	bne	.L3095
.L2953:
	ldr	x1, [x7]
	cbz	x1, .L2952
	ldrb	w0, [x19, 456]
	ldr	w26, [x1, 16]
	cbz	w0, .L2956
	ldr	x3, [x19, 24]
	uxtw	x0, w26
	ldr	x2, [x19, 256]
	ldr	x1, [x19, 240]
	madd	x0, x0, x3, x2
	add	x0, x0, x1
	ldrb	w0, [x0, 2]
	tbnz	x0, 0, .L3096
.L2956:
	add	x20, sp, 208
	mov	x0, x20
.LEHB239:
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
	ldr	x3, [x19, 24]
	uxtw	x0, w26
	ldr	x2, [x19, 256]
	ldr	x1, [x19, 240]
	madd	x0, x0, x3, x2
	add	x0, x0, x1
	ldrb	w0, [x0, 2]
	tbnz	x0, 0, .L3097
.L2959:
	fmov	s0, 1.0e+0
	mov	x1, x23
	mov	x0, x19
	mov	w2, w26
	bl	_ZN7hnswlib15HierarchicalNSWIfE11updatePointEPKvjf
	ldrb	w0, [sp, 216]
	cbnz	w0, .L3098
.L2950:
	mov	w0, w26
	ldp	x19, x20, [sp, 16]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	.cfi_remember_state
	.cfi_restore 26
	.cfi_restore 25
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 240
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L3097:
	.cfi_restore_state
	mov	w1, w26
	mov	x0, x19
	bl	_ZN7hnswlib15HierarchicalNSWIfE21unmarkDeletedInternalEj
	b	.L2959
	.p2align 2,,3
.L2952:
	add	x1, x19, 16
	ldar	x2, [x1]
	ldr	x3, [x19, 8]
	cmp	x3, x2
	bls	.L3099
	ldar	x20, [x1]
	str	x20, [sp, 144]
	mov	w26, w20
.L3111:
	ldaxr	x2, [x1]
	add	x2, x2, 1
	stlxr	w3, x2, [x1]
	cbnz	w3, .L3111
	add	x1, sp, 152
	bl	_ZNSt8__detail9_Map_baseImSt4pairIKmjESaIS3_ENS_10_Select1stESt8equal_toImESt4hashImENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_20_Prime_rehash_policyENS_17_Hashtable_traitsILb0ELb0ELb1EEELb1EEixERS2_
.LEHE239:
	ldrb	w1, [sp, 216]
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -200
	.cfi_offset 21, -208
	str	d8, [sp, 96]
	.cfi_offset 72, -144
	str	w20, [x0]
	cbnz	w1, .L3100
.L2962:
	ldr	x20, [sp, 144]
	add	x0, sp, 176
	ldr	x2, [x19, 192]
	strb	wzr, [sp, 184]
	ubfiz	x1, x20, 1, 32
	add	x1, x1, x20, uxtw
	and	x20, x20, 4294967295
	add	x1, x2, x1, lsl 4
	str	x1, [sp, 176]
.LEHB240:
	bl	_ZNSt11unique_lockISt5mutexE4lockEv
.LEHE240:
	ldr	x1, [x19, 424]
	mov	x4, 16807
	mov	x3, 5
	mov	x0, 281474968322048
	movk	x3, 0x2, lsl 32
	movk	x0, 0x41df, lsl 48
	mul	x1, x1, x4
	fmov	d3, x0
	mov	x0, 281474959933440
	movi	d4, #0
	movk	x0, 0x43cf, lsl 48
	fmov	d2, x0
	mov	w0, 1
	strb	w0, [sp, 184]
	umulh	x2, x1, x3
	fmov	d5, 1.0e+0
	ldr	d8, [x19, 88]
	sub	x0, x1, x2
	add	x0, x2, x0, lsr 1
	lsr	x0, x0, 30
	lsl	x2, x0, 31
	sub	x0, x2, x0
	sub	x0, x1, x0
	sub	x2, x0, #1
	mul	x1, x0, x4
	ucvtf	d0, x2
	umulh	x2, x1, x3
	fadd	d1, d0, d4
	sub	x0, x1, x2
	add	x0, x2, x0, lsr 1
	lsr	x0, x0, 30
	lsl	x2, x0, 31
	sub	x0, x2, x0
	sub	x0, x1, x0
	str	x0, [x19, 424]
	sub	x0, x0, #1
	ucvtf	d0, x0
	fmadd	d0, d0, d3, d1
	fdiv	d0, d0, d2
	fcmpe	d0, d5
	bge	.L3015
	fadd	d0, d0, d4
.L2963:
	bl	log
	ldr	w0, [sp, 136]
	cmp	w0, 0
	bgt	.L2964
	fnmul	d0, d0, d8
	fcvtzs	w0, d0
	str	w0, [sp, 136]
.L2964:
	ldr	x2, [x19, 272]
	add	x1, x19, 144
	ldr	w21, [sp, 136]
	add	x0, sp, 192
	str	w21, [x2, x20, lsl 2]
	str	x1, [sp, 192]
	strb	wzr, [sp, 200]
.LEHB241:
	bl	_ZNSt11unique_lockISt5mutexE4lockEv
.LEHE241:
	ldr	w0, [x19, 104]
	mov	w1, w0
	mov	w0, 1
	str	w1, [sp, 140]
	strb	w0, [sp, 200]
	cmp	w1, w21
	blt	.L2968
	add	x0, sp, 192
.LEHB242:
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
.L2968:
	ldr	x2, [x19, 24]
	mov	w1, 0
	ldr	x0, [x19, 240]
	ldr	x3, [x19, 256]
	madd	x0, x2, x20, x0
	ldr	w24, [x19, 216]
	str	w24, [sp, 168]
	add	x0, x3, x0
	bl	memset
	ldp	x2, x3, [x19, 248]
	mov	x1, x23
	ldr	x0, [x19, 24]
	madd	x0, x20, x0, x3
	ldr	x3, [sp, 152]
	str	x3, [x0, x2]
	ldr	x0, [x19, 24]
	ldr	x4, [x19, 232]
	ldr	x3, [x19, 256]
	ldr	x2, [x19, 296]
	madd	x0, x20, x0, x4
	add	x0, x3, x0
	bl	memcpy
	ldr	w0, [sp, 136]
	cbnz	w0, .L3101
.L2967:
	cmn	w24, #1
	beq	.L2970
	ldp	w0, w20, [sp, 136]
	ldr	x4, [x19, 24]
	ldr	x3, [x19, 256]
	cmp	w20, w0
	ble	.L2971
	ldr	x6, [x19, 232]
	uxtw	x1, w24
	ldp	x5, x2, [x19, 304]
	mov	x0, x23
	madd	x1, x1, x4, x6
	add	x1, x3, x1
	blr	x5
.LEHE242:
	fmov	s8, s0
	sxtw	x0, w20
	sub	w27, w20, #1
	add	x28, x19, 192
	sub	x0, x0, #1
	str	x0, [sp, 120]
	.p2align 3,,7
.L2981:
	ldr	x0, [x28]
	mov	w1, 48
	strb	wzr, [sp, 216]
	umaddl	x0, w24, w1, x0
	str	x0, [sp, 208]
	cbz	x0, .L3102
	ldr	x1, [sp, 112]
	cbz	x1, .L2973
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L3103
.L2973:
	mov	w1, 1
	strb	w1, [sp, 216]
	ldr	x0, [x19, 32]
	str	w27, [sp, 132]
	ldr	x2, [sp, 120]
	ldr	x1, [x19, 264]
	mul	x0, x2, x0
	ldr	x1, [x1, w24, uxtw 3]
	add	x20, x1, x0
	ldrh	w22, [x1, x0]
	cbz	w22, .L3104
	sub	w22, w22, #1
	add	x0, x20, 8
	add	x20, x20, 4
	mov	w25, 0
	add	x22, x0, x22, uxtw 2
	.p2align 3,,7
.L2979:
	ldr	w21, [x20]
	ldr	x0, [x19, 8]
	uxtw	x1, w21
	cmp	x1, x0
	bhi	.L3105
	ldr	x5, [x19, 24]
	mov	x0, x23
	ldr	x4, [x19, 232]
	ldp	x3, x2, [x19, 304]
	madd	x1, x1, x5, x4
	ldr	x4, [x19, 256]
	add	x1, x4, x1
.LEHB243:
	blr	x3
.LEHE243:
	fcmpe	s0, s8
	bmi	.L3027
.L2977:
	add	x20, x20, 4
	cmp	x22, x20
	bne	.L2979
	ldrb	w0, [sp, 216]
	cbnz	w0, .L3106
	cbnz	w25, .L2981
	.p2align 3,,7
.L2975:
	ldr	x0, [sp, 120]
	sub	w27, w27, #1
	ldr	w1, [sp, 132]
	sub	x0, x0, #1
	str	x0, [sp, 120]
	ldr	w0, [sp, 136]
	cmp	w0, w1
	blt	.L2981
	ldr	w0, [sp, 168]
	ldr	x3, [x19, 24]
	ldr	x2, [x19, 256]
	ldr	x1, [x19, 240]
	madd	x0, x0, x3, x2
	add	x0, x0, x1
	ldrb	w22, [x0, 2]
	ldr	w0, [sp, 136]
	and	w22, w22, 1
	tbnz	w0, #31, .L2996
	mov	w21, w0
.L2984:
	add	x20, sp, 208
	b	.L2988
	.p2align 2,,3
.L2990:
	mov	w3, w21
	mov	x2, x20
	mov	w1, w26
	mov	x0, x19
	mov	w4, 0
.LEHB244:
	bl	_ZN7hnswlib15HierarchicalNSWIfE25mutuallyConnectNewElementEPKvjRSt14priority_queueISt4pairIfjESt6vectorIS6_SaIS6_EENS1_14CompareByFirstEEib.isra.0
.LEHE244:
	ldr	x1, [sp, 208]
	mov	w24, w0
	cbz	x1, .L2992
	mov	x0, x1
	bl	_ZdlPv
.L2992:
	subs	w21, w21, #1
	bmi	.L2985
	ldr	w0, [sp, 140]
	cmp	w0, w21
	blt	.L3107
.L2988:
	mov	w1, w24
	mov	x8, x20
	mov	w3, w21
	mov	x2, x23
	mov	x0, x19
.LEHB245:
	bl	_ZN7hnswlib15HierarchicalNSWIfE15searchBaseLayerEjPKvi
.LEHE245:
	cbz	w22, .L2990
	ldr	w1, [sp, 168]
	mov	x0, x23
	ldr	x5, [x19, 24]
	ldr	x4, [x19, 232]
	ldp	x3, x2, [x19, 304]
	madd	x1, x1, x5, x4
	ldr	x4, [x19, 256]
	add	x1, x4, x1
.LEHB246:
	blr	x3
	add	x2, sp, 168
	add	x1, sp, 172
	mov	x0, x20
	str	s0, [sp, 172]
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE7emplaceIJfRjEEEvDpOT_
.LEHE246:
	ldp	x2, x0, [sp, 208]
	ldr	x1, [x19, 72]
	sub	x0, x0, x2
	cmp	x1, x0, asr 3
	bcs	.L2990
	mov	x0, x20
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	b	.L2990
.L3098:
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 72
	mov	x0, x20
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
	mov	w0, w26
	ldp	x19, x20, [sp, 16]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	.cfi_restore 26
	.cfi_restore 25
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 240
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L3106:
	.cfi_def_cfa_offset 240
	.cfi_offset 19, -224
	.cfi_offset 20, -216
	.cfi_offset 21, -208
	.cfi_offset 22, -200
	.cfi_offset 23, -192
	.cfi_offset 24, -184
	.cfi_offset 25, -176
	.cfi_offset 26, -168
	.cfi_offset 27, -160
	.cfi_offset 28, -152
	.cfi_offset 29, -240
	.cfi_offset 30, -232
	.cfi_offset 72, -144
	add	x0, sp, 208
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
	cbnz	w25, .L2981
	b	.L2975
	.p2align 2,,3
.L3100:
	add	x0, sp, 208
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
	b	.L2962
	.p2align 2,,3
.L3027:
	fmov	s8, s0
	mov	w24, w21
	mov	w25, 1
	b	.L2977
.L2970:
	ldr	w0, [sp, 136]
	str	w0, [x19, 104]
	str	wzr, [x19, 216]
.L2985:
	ldp	w0, w1, [sp, 136]
	cmp	w1, w0
	bge	.L2996
	str	w0, [x19, 104]
	ldr	w0, [sp, 144]
	str	w0, [x19, 216]
.L2996:
	ldrb	w0, [sp, 200]
	cbnz	w0, .L3108
.L2997:
	ldrb	w0, [sp, 184]
	cbnz	w0, .L3109
	mov	w0, w26
	ldr	d8, [sp, 96]
	.cfi_remember_state
	.cfi_restore 72
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	.cfi_restore 22
	.cfi_restore 21
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	.cfi_restore 26
	.cfi_restore 25
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 240
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L3104:
	.cfi_restore_state
	add	x0, sp, 208
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
	b	.L2975
.L3101:
	ldrsw	x21, [sp, 136]
	ldr	x0, [x19, 32]
	ldr	x22, [x19, 264]
	mul	x21, x21, x0
	add	x21, x21, 1
	mov	x0, x21
	bl	malloc
	str	x0, [x22, x20, lsl 3]
	cbz	x0, .L3110
	mov	x2, x21
	mov	w1, 0
	bl	memset
	b	.L2967
.L2971:
	ldr	w0, [sp, 168]
	ldr	x1, [x19, 240]
	ldr	w2, [sp, 140]
	madd	x0, x0, x4, x3
	mov	w21, w2
	add	x0, x0, x1
	ldrb	w22, [x0, 2]
	and	w22, w22, 1
	tbz	w2, #31, .L2984
	b	.L2985
.L3109:
	add	x0, sp, 176
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
	ldp	x21, x22, [sp, 32]
	.cfi_remember_state
	.cfi_restore 22
	.cfi_restore 21
	ldr	d8, [sp, 96]
	.cfi_restore 72
	b	.L2950
.L3108:
	.cfi_restore_state
	add	x0, sp, 192
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
	b	.L2997
.L3015:
	mov	x0, 4607182418800017407
	fmov	d0, x0
	b	.L2963
.L3103:
.LEHB247:
	bl	_ZSt20__throw_system_errori
.L3102:
	mov	w0, 1
	bl	_ZSt20__throw_system_errori
.LEHE247:
.L3094:
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 72
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -200
	.cfi_offset 21, -208
	stp	x25, x26, [sp, 64]
	.cfi_offset 26, -168
	.cfi_offset 25, -176
	str	d8, [sp, 96]
	.cfi_offset 72, -144
.LEHB248:
	bl	_ZSt20__throw_system_errori
.LEHE248:
.L3021:
	mov	x19, x0
.L3003:
	ldrb	w0, [sp, 200]
	cbz	w0, .L3011
	add	x0, sp, 192
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
.L3011:
	ldrb	w0, [sp, 184]
	cbz	w0, .L3012
	add	x0, sp, 176
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
.L3012:
	mov	x0, x19
.LEHB249:
	bl	_Unwind_Resume
.LEHE249:
.L3020:
	mov	x19, x0
	b	.L3011
.L3096:
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 72
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC82
	mov	x20, x0
	add	x1, x1, :lo12:.LC82
.LEHB250:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE250:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x20
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB251:
	bl	__cxa_throw
.LEHE251:
.L3107:
	.cfi_offset 21, -208
	.cfi_offset 22, -200
	.cfi_offset 72, -144
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC86
	mov	x20, x0
	add	x1, x1, :lo12:.LC86
.LEHB252:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE252:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x20
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB253:
	bl	__cxa_throw
.LEHE253:
.L3018:
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 72
.L3092:
	mov	x19, x0
	mov	x0, x20
	bl	__cxa_free_exception
.L2999:
	ldrb	w0, [sp, 216]
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -200
	.cfi_offset 21, -208
	str	d8, [sp, 96]
	.cfi_offset 72, -144
	cbz	w0, .L3012
	add	x0, sp, 208
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
	b	.L3012
.L3025:
.L3093:
	mov	x19, x0
	mov	x0, x20
	bl	__cxa_free_exception
	b	.L3003
.L3026:
	ldr	x1, [sp, 208]
	mov	x19, x0
	cbz	x1, .L3003
	mov	x0, x1
	bl	_ZdlPv
	b	.L3003
.L3110:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC84
	mov	x20, x0
	add	x1, x1, :lo12:.LC84
.LEHB254:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE254:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x20
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB255:
	bl	__cxa_throw
.LEHE255:
.L3022:
	b	.L3093
.L3024:
	mov	x19, x0
.L3005:
	ldrb	w0, [sp, 216]
	cbz	w0, .L3003
	add	x0, sp, 208
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
	b	.L3003
.L3105:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC85
	mov	x20, x0
	add	x1, x1, :lo12:.LC85
.LEHB256:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE256:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x20
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB257:
	bl	__cxa_throw
.LEHE257:
.L3023:
	mov	x19, x0
	mov	x0, x20
	bl	__cxa_free_exception
	b	.L3005
.L3099:
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 72
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC83
	mov	x20, x0
	add	x1, x1, :lo12:.LC83
.LEHB258:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE258:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x20
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB259:
	bl	__cxa_throw
.LEHE259:
.L3017:
	mov	x19, x0
	b	.L2999
.L3019:
	b	.L3092
	.cfi_endproc
.LFE11490:
	.section	.gcc_except_table
.LLSDA11490:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE11490-.LLSDACSB11490
.LLSDACSB11490:
	.uleb128 .LEHB239-.LFB11490
	.uleb128 .LEHE239-.LEHB239
	.uleb128 .L3017-.LFB11490
	.uleb128 0
	.uleb128 .LEHB240-.LFB11490
	.uleb128 .LEHE240-.LEHB240
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB241-.LFB11490
	.uleb128 .LEHE241-.LEHB241
	.uleb128 .L3020-.LFB11490
	.uleb128 0
	.uleb128 .LEHB242-.LFB11490
	.uleb128 .LEHE242-.LEHB242
	.uleb128 .L3021-.LFB11490
	.uleb128 0
	.uleb128 .LEHB243-.LFB11490
	.uleb128 .LEHE243-.LEHB243
	.uleb128 .L3024-.LFB11490
	.uleb128 0
	.uleb128 .LEHB244-.LFB11490
	.uleb128 .LEHE244-.LEHB244
	.uleb128 .L3026-.LFB11490
	.uleb128 0
	.uleb128 .LEHB245-.LFB11490
	.uleb128 .LEHE245-.LEHB245
	.uleb128 .L3021-.LFB11490
	.uleb128 0
	.uleb128 .LEHB246-.LFB11490
	.uleb128 .LEHE246-.LEHB246
	.uleb128 .L3026-.LFB11490
	.uleb128 0
	.uleb128 .LEHB247-.LFB11490
	.uleb128 .LEHE247-.LEHB247
	.uleb128 .L3021-.LFB11490
	.uleb128 0
	.uleb128 .LEHB248-.LFB11490
	.uleb128 .LEHE248-.LEHB248
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB249-.LFB11490
	.uleb128 .LEHE249-.LEHB249
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB250-.LFB11490
	.uleb128 .LEHE250-.LEHB250
	.uleb128 .L3018-.LFB11490
	.uleb128 0
	.uleb128 .LEHB251-.LFB11490
	.uleb128 .LEHE251-.LEHB251
	.uleb128 .L3017-.LFB11490
	.uleb128 0
	.uleb128 .LEHB252-.LFB11490
	.uleb128 .LEHE252-.LEHB252
	.uleb128 .L3025-.LFB11490
	.uleb128 0
	.uleb128 .LEHB253-.LFB11490
	.uleb128 .LEHE253-.LEHB253
	.uleb128 .L3021-.LFB11490
	.uleb128 0
	.uleb128 .LEHB254-.LFB11490
	.uleb128 .LEHE254-.LEHB254
	.uleb128 .L3022-.LFB11490
	.uleb128 0
	.uleb128 .LEHB255-.LFB11490
	.uleb128 .LEHE255-.LEHB255
	.uleb128 .L3021-.LFB11490
	.uleb128 0
	.uleb128 .LEHB256-.LFB11490
	.uleb128 .LEHE256-.LEHB256
	.uleb128 .L3023-.LFB11490
	.uleb128 0
	.uleb128 .LEHB257-.LFB11490
	.uleb128 .LEHE257-.LEHB257
	.uleb128 .L3024-.LFB11490
	.uleb128 0
	.uleb128 .LEHB258-.LFB11490
	.uleb128 .LEHE258-.LEHB258
	.uleb128 .L3019-.LFB11490
	.uleb128 0
	.uleb128 .LEHB259-.LFB11490
	.uleb128 .LEHE259-.LEHB259
	.uleb128 .L3017-.LFB11490
	.uleb128 0
.LLSDACSE11490:
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmi,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmi,comdat
	.size	_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmi, .-_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmi
	.text
	.align	2
	.p2align 4,,11
	.type	_Z11build_indexPfmm._omp_fn.0, %function
_Z11build_indexPfmm._omp_fn.0:
.LFB13026:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA13026
	stp	x29, x30, [sp, -112]!
	.cfi_def_cfa_offset 112
	.cfi_offset 29, -112
	.cfi_offset 30, -104
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -80
	.cfi_offset 22, -72
	mov	x22, x0
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	.cfi_offset 19, -96
	.cfi_offset 20, -88
	.cfi_offset 23, -64
	.cfi_offset 24, -56
	bl	omp_get_num_threads
	mov	w20, w0
	bl	omp_get_thread_num
	mov	w19, w0
	ldr	x1, [x22, 8]
	sub	w0, w1, #1
	sdiv	w23, w0, w20
	msub	w1, w23, w20, w0
	cmp	w19, w1
	blt	.L3113
.L3123:
	madd	w19, w23, w19, w1
	add	w23, w23, w19
	cmp	w19, w23
	bge	.L3112
	ldr	x20, [x22]
	add	w19, w19, 1
	ldp	x24, x22, [x22, 16]
	sxtw	x21, w19
	add	w23, w23, 1
	stp	x25, x26, [sp, 64]
	.cfi_offset 26, -40
	.cfi_offset 25, -48
	adrp	x25, _ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmb
	mov	w26, 48
	add	x25, x25, :lo12:_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmb
	stp	x27, x28, [sp, 80]
	.cfi_offset 28, -24
	.cfi_offset 27, -32
	mov	w27, 1
	lsl	x24, x24, 2
	madd	x20, x21, x24, x20
	b	.L3122
	.p2align 2,,3
.L3119:
	add	w19, w19, 1
	add	x20, x20, x24
	add	x21, x21, 1
	cmp	w19, w23
	beq	.L3145
.L3122:
	ldr	x0, [x22]
	ldr	x4, [x0]
	cmp	x4, x25
	bne	.L3115
	ldr	x1, [x22, 120]
	and	w0, w19, 65535
	strb	wzr, [sp, 104]
	smaddl	x0, w0, w26, x1
	str	x0, [sp, 96]
	cbz	x0, .L3146
	adrp	x1, .LC36
	add	x1, x1, :lo12:.LC36
	ldr	x1, [x1]
	cbz	x1, .L3117
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L3147
.L3117:
	mov	x2, x21
	mov	x1, x20
	mov	x0, x22
	mov	w3, -1
	strb	w27, [sp, 104]
.LEHB260:
	bl	_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmi
.LEHE260:
	ldrb	w0, [sp, 104]
	cbz	w0, .L3119
	ldr	x0, [sp, 96]
	cbz	x0, .L3119
	adrp	x1, .LC36
	add	x1, x1, :lo12:.LC36
	ldr	x1, [x1]
	cbz	x1, .L3119
	add	w19, w19, 1
	bl	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t
	add	x20, x20, x24
	add	x21, x21, 1
	cmp	w19, w23
	bne	.L3122
	.p2align 3,,7
.L3145:
	ldp	x25, x26, [sp, 64]
	.cfi_restore 26
	.cfi_restore 25
	ldp	x27, x28, [sp, 80]
	.cfi_restore 28
	.cfi_restore 27
.L3112:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x29, x30, [sp], 112
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L3115:
	.cfi_def_cfa_offset 112
	.cfi_offset 19, -96
	.cfi_offset 20, -88
	.cfi_offset 21, -80
	.cfi_offset 22, -72
	.cfi_offset 23, -64
	.cfi_offset 24, -56
	.cfi_offset 25, -48
	.cfi_offset 26, -40
	.cfi_offset 27, -32
	.cfi_offset 28, -24
	.cfi_offset 29, -112
	.cfi_offset 30, -104
	mov	x2, x21
	mov	x1, x20
	mov	x0, x22
	mov	w3, 0
	blr	x4
	b	.L3119
	.p2align 2,,3
.L3113:
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 27
	.cfi_restore 28
	add	w23, w23, 1
	mov	w1, 0
	b	.L3123
.L3146:
	.cfi_offset 25, -48
	.cfi_offset 26, -40
	.cfi_offset 27, -32
	.cfi_offset 28, -24
	mov	w0, 1
.LEHB261:
	bl	_ZSt20__throw_system_errori
.L3147:
	bl	_ZSt20__throw_system_errori
.LEHE261:
.L3124:
	ldrb	w1, [sp, 104]
	mov	x19, x0
	cbz	w1, .L3121
	add	x0, sp, 96
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
.L3121:
	mov	x0, x19
.LEHB262:
	bl	_Unwind_Resume
.LEHE262:
	.cfi_endproc
.LFE13026:
	.section	.gcc_except_table
.LLSDA13026:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE13026-.LLSDACSB13026
.LLSDACSB13026:
	.uleb128 .LEHB260-.LFB13026
	.uleb128 .LEHE260-.LEHB260
	.uleb128 .L3124-.LFB13026
	.uleb128 0
	.uleb128 .LEHB261-.LFB13026
	.uleb128 .LEHE261-.LEHB261
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB262-.LFB13026
	.uleb128 .LEHE262-.LEHB262
	.uleb128 0
	.uleb128 0
.LLSDACSE13026:
	.text
	.size	_Z11build_indexPfmm._omp_fn.0, .-_Z11build_indexPfmm._omp_fn.0
	.section	.rodata.str1.8
	.align	3
.LC87:
	.string	"Not enough memory"
	.align	3
.LC88:
	.string	"Not enough memory: HierarchicalNSW failed to allocate linklists"
	.text
	.align	2
	.p2align 4,,11
	.global	_Z11build_indexPfmm
	.type	_Z11build_indexPfmm, %function
_Z11build_indexPfmm:
.LFB10504:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA10504
	sub	sp, sp, #1216
	.cfi_def_cfa_offset 1216
	lsl	x3, x2, 2
	stp	x29, x30, [sp]
	.cfi_offset 29, -1216
	.cfi_offset 30, -1208
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -1184
	.cfi_offset 22, -1176
	mov	x21, x1
	adrp	x1, _ZN7hnswlibL20InnerProductDistanceEPKvS1_S1_
	add	x1, x1, :lo12:_ZN7hnswlibL20InnerProductDistanceEPKvS1_S1_
	stp	x25, x26, [sp, 64]
	.cfi_offset 25, -1152
	.cfi_offset 26, -1144
	mov	x25, x2
	adrp	x2, _ZTVN7hnswlib17InnerProductSpaceE+16
	add	x2, x2, :lo12:_ZTVN7hnswlib17InnerProductSpaceE+16
	stp	x19, x20, [sp, 16]
	stp	x23, x24, [sp, 48]
	stp	x27, x28, [sp, 80]
	.cfi_offset 19, -1200
	.cfi_offset 20, -1192
	.cfi_offset 23, -1168
	.cfi_offset 24, -1160
	.cfi_offset 27, -1136
	.cfi_offset 28, -1128
	mov	x27, x0
	mov	x0, 568
	stp	x2, x1, [sp, 128]
	stp	x3, x25, [sp, 144]
.LEHB263:
	bl	_Znwm
.LEHE263:
	mov	x19, x0
	add	x22, x0, 120
	adrp	x1, _ZTVN7hnswlib15HierarchicalNSWIfEE+16
	add	x1, x1, :lo12:_ZTVN7hnswlib15HierarchicalNSWIfEE+16
	mov	x0, 3145728
	stp	x1, xzr, [x19]
	stp	xzr, xzr, [x19, 16]
	stp	xzr, xzr, [x19, 32]
	stp	xzr, xzr, [x19, 48]
	stp	xzr, xzr, [x19, 64]
	str	xzr, [x19, 80]
	stp	xzr, xzr, [x19, 88]
	str	wzr, [x19, 104]
	stp	xzr, xzr, [x19, 112]
	stp	xzr, xzr, [x22, 8]
.LEHB264:
	bl	_Znwm
.LEHE264:
	str	x0, [x19, 120]
	mov	x2, 3145728
	add	x20, x0, x2
	str	x20, [x22, 16]
	mov	w1, 0
	bl	memset
	str	x20, [x22, 8]
	mov	x1, -6148914691236517206
	stp	xzr, xzr, [x19, 144]
	movk	x1, 0x2aa, lsl 48
	stp	xzr, xzr, [x19, 160]
	stp	xzr, xzr, [x19, 176]
	cmp	x21, x1
	bhi	.L3272
	add	x23, x19, 192
	str	xzr, [x19, 192]
	add	x20, x21, x21, lsl 1
	stp	xzr, xzr, [x23, 8]
	lsl	x20, x20, 4
	cbz	x21, .L3150
	mov	x0, x20
.LEHB265:
	bl	_Znwm
.LEHE265:
	str	x0, [x19, 192]
	mov	x2, x20
	add	x20, x0, x20
	str	x20, [x23, 16]
	add	x22, x19, 272
	mov	w1, 0
	bl	memset
	str	x20, [x23, 8]
	str	wzr, [x19, 216]
	lsl	x23, x21, 2
	stp	xzr, xzr, [x19, 224]
	mov	x0, x23
	stp	xzr, xzr, [x19, 240]
	stp	xzr, xzr, [x19, 256]
	str	xzr, [x19, 272]
	stp	xzr, xzr, [x22, 8]
.LEHB266:
	bl	_Znwm
.LEHE266:
	str	x0, [x19, 272]
	add	x20, x0, x23
	str	x20, [x22, 16]
	mov	x2, x23
	mov	w1, 0
	bl	memset
.L3206:
	add	x28, x19, 368
	str	x20, [x22, 8]
	add	x3, x19, 416
	str	xzr, [x19, 296]
	str	xzr, [x19, 312]
	mov	x0, 1
	stp	xzr, xzr, [x19, 320]
	fmov	s0, 1.0e+0
	add	x24, x19, 512
	stp	xzr, xzr, [x19, 336]
	add	x2, x19, 560
	stp	xzr, xzr, [x19, 352]
	str	x3, [x19, 368]
	str	x0, [x28, 8]
	str	xzr, [x19, 384]
	str	xzr, [x28, 24]
	str	xzr, [x19, 408]
	str	s0, [x19, 400]
	str	xzr, [x28, 48]
	stp	x0, x0, [x19, 424]
	stp	xzr, xzr, [x19, 440]
	strb	wzr, [x19, 456]
	stp	xzr, xzr, [x19, 464]
	stp	xzr, xzr, [x19, 480]
	stp	xzr, xzr, [x19, 496]
	str	x2, [x19, 512]
	str	x0, [x24, 8]
	str	xzr, [x19, 528]
	str	xzr, [x24, 24]
	str	s0, [x24, 32]
	stp	xzr, xzr, [x24, 40]
	str	x21, [x19, 8]
	add	x0, x19, 40
	stlr	xzr, [x0]
	ldp	x7, x1, [sp, 136]
	add	x6, sp, 152
	ldr	x0, [x19, 8]
	mov	x11, 32
	mov	x10, 150
	mov	x9, 10
	mov	x5, 100
	mov	x4, 101
	add	x3, x1, 140
	add	x8, x1, 132
	mov	x2, 132
	mov	x20, 16
	str	x3, [x19, 24]
	mul	x0, x3, x0
	stp	x20, x20, [x19, 48]
	stp	x11, x10, [x19, 64]
	str	x9, [x19, 80]
	stp	x2, x2, [x19, 224]
	stp	xzr, x8, [x19, 240]
	stp	x1, x7, [x19, 296]
	str	x6, [x19, 312]
	stp	x5, x4, [x19, 424]
	bl	malloc
	str	x0, [x19, 256]
	cbz	x0, .L3273
	add	x0, x19, 16
	stlr	xzr, [x0]
	mov	x0, 136
.LEHB267:
	bl	_Znwm
.LEHE267:
	mov	x20, x0
	mov	x1, 8
	mov	x22, x20
	add	x23, x20, 48
	mov	x0, 64
	str	xzr, [x22], 16
	str	xzr, [x20, 16]
	stp	xzr, xzr, [x22, 8]
	str	xzr, [x22, 24]
	str	xzr, [x20, 48]
	stp	xzr, xzr, [x23, 8]
	str	xzr, [x23, 24]
	str	x1, [x20, 8]
.LEHB268:
	bl	_Znwm
.LEHE268:
	ldr	x1, [x20, 8]
	mov	x26, x0
	str	x26, [x20]
	mov	x0, 512
	sub	x1, x1, #1
	lsr	x1, x1, 1
	add	x3, x26, x1, lsl 3
	stp	x3, x1, [sp, 96]
.LEHB269:
	bl	_Znwm
.LEHE269:
	ldp	x4, x2, [sp, 96]
	add	x3, x0, 512
	stp	x0, x3, [x22, 8]
	mov	x1, x0
	str	x4, [x22, 24]
	stp	x1, x3, [x23, 8]
	str	x4, [x23, 24]
	str	x0, [x26, x2, lsl 3]
	mov	x0, 24
	str	x1, [x20, 16]
	str	x1, [x20, 48]
	stp	xzr, xzr, [x20, 80]
	stp	xzr, xzr, [x20, 96]
	stp	xzr, xzr, [x20, 112]
	str	w21, [x20, 128]
.LEHB270:
	bl	_Znwm
.LEHE270:
	mov	x26, x0
	ldr	w1, [x20, 128]
	mov	w2, -1
	strh	w2, [x0]
	str	w1, [x26, 16]
	ubfiz	x0, x1, 1, 32
.LEHB271:
	bl	_Znam
.LEHE271:
	ldp	x1, x2, [x20, 16]
	str	x0, [x26, 8]
	cmp	x2, x1
	beq	.L3274
	mov	x0, x1
	str	x26, [x0, -8]!
	str	x0, [x20, 16]
.L3158:
	ldr	x26, [x19, 112]
	str	x20, [x19, 112]
	cbz	x26, .L3161
	add	x22, x26, 48
	add	x20, x26, 16
	.p2align 3,,7
.L3172:
	ldp	x2, x3, [x22]
	ldr	x23, [x20, 24]
	ldr	x5, [x22, 24]
	sub	x2, x2, x3
	sub	x0, x5, x23
	ldr	x1, [x20]
	asr	x0, x0, 3
	ldr	x3, [x20, 16]
	sub	x0, x0, #1
	asr	x2, x2, 3
	sub	x4, x3, x1
	add	x0, x2, x0, lsl 6
	add	x0, x0, x4, asr 3
	cbz	x0, .L3169
	sub	x3, x3, #8
	ldr	x23, [x1]
	cmp	x1, x3
	beq	.L3170
	add	x1, x1, 8
	str	x1, [x26, 16]
	cbz	x23, .L3172
.L3275:
	ldr	x0, [x23, 8]
	cbz	x0, .L3173
	bl	_ZdaPv
.L3173:
	mov	x0, x23
	bl	_ZdlPv
	b	.L3172
	.p2align 2,,3
.L3170:
	ldr	x0, [x26, 24]
	bl	_ZdlPv
	ldr	x0, [x26, 40]
	add	x1, x0, 8
	ldr	x0, [x0, 8]
	str	x0, [x20, 8]
	str	x1, [x20, 24]
	add	x1, x0, 512
	str	x1, [x20, 16]
	str	x0, [x26, 16]
	cbz	x23, .L3172
	b	.L3275
	.p2align 2,,3
.L3169:
	ldr	x0, [x26]
	cbz	x0, .L3174
	add	x20, x5, 8
	cmp	x23, x20
	bcs	.L3175
	.p2align 3,,7
.L3176:
	ldr	x0, [x23], 8
	bl	_ZdlPv
	cmp	x20, x23
	bhi	.L3176
	ldr	x0, [x26]
.L3175:
	bl	_ZdlPv
.L3174:
	mov	x0, x26
	bl	_ZdlPv
.L3161:
	ldr	x0, [x19, 8]
	mov	w1, -1
	str	w1, [x19, 104]
	str	w1, [x19, 216]
	lsl	x0, x0, 3
	bl	malloc
	str	x0, [x19, 264]
	cbz	x0, .L3276
	ldr	d0, [x19, 48]
	ldr	x0, [x19, 56]
	ucvtf	d0, d0
	add	x0, x0, 1
	lsl	x0, x0, 2
	str	x0, [x19, 32]
	bl	log
	strb	wzr, [sp, 200]
	fmov	d1, 1.0e+0
	ldr	x0, [x19, 120]
	str	x0, [sp, 192]
	fdiv	d0, d1, d0
	fdiv	d1, d1, d0
	stp	d0, d1, [x19, 88]
	cbz	x0, .L3277
	adrp	x1, .LC36
	ldr	x1, [x1, #:lo12:.LC36]
	cbz	x1, .L3199
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L3278
.L3199:
	mov	w4, 1
	mov	x1, x27
	mov	x0, x19
	mov	w3, -1
	mov	x2, 0
	strb	w4, [sp, 200]
.LEHB272:
	bl	_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmi
.LEHE272:
	ldrb	w0, [sp, 200]
	cbnz	w0, .L3279
.L3200:
	add	x1, sp, 192
	mov	w3, 0
	mov	w2, 0
	adrp	x0, _Z11build_indexPfmm._omp_fn.0
	add	x0, x0, :lo12:_Z11build_indexPfmm._omp_fn.0
	stp	x27, x21, [sp, 192]
	stp	x25, x19, [sp, 208]
	bl	GOMP_parallel
	adrp	x3, .LANCHOR0
	add	x3, x3, :lo12:.LANCHOR0
	mov	x2, 1007
	mov	w1, 0
	add	x0, sp, 209
	ldp	x4, x5, [x3, 192]
	stp	x4, x5, [sp, 192]
	ldrb	w3, [x3, 208]
	strb	w3, [sp, 208]
	bl	memset
	ldr	x3, [x19]
	add	x4, sp, 176
	mov	x5, 16
	add	x1, sp, 120
	mov	x2, 0
	add	x0, sp, 160
	str	x5, [sp, 120]
	str	x4, [sp, 160]
	ldr	x20, [x3, 24]
.LEHB273:
	bl	_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEE9_M_createERmm
.LEHE273:
	ldr	x2, [sp, 120]
	str	x0, [sp, 160]
	str	x2, [sp, 176]
	add	x1, sp, 160
	ldp	x2, x3, [sp, 192]
	stp	x2, x3, [x0]
	mov	x0, x19
	ldr	x2, [sp, 120]
	str	x2, [sp, 168]
	ldr	x3, [sp, 160]
	strb	wzr, [x3, x2]
.LEHB274:
	blr	x20
.LEHE274:
	ldr	x0, [sp, 160]
	add	x1, sp, 176
	cmp	x0, x1
	beq	.L3148
	bl	_ZdlPv
.L3148:
	ldp	x29, x30, [sp]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	add	sp, sp, 1216
	.cfi_remember_state
	.cfi_restore 29
	.cfi_restore 30
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L3150:
	.cfi_restore_state
	add	x22, x19, 272
	str	xzr, [x19, 192]
	stp	xzr, xzr, [x23, 8]
	mov	x20, 0
	str	wzr, [x19, 216]
	stp	xzr, xzr, [x19, 224]
	stp	xzr, xzr, [x19, 240]
	stp	xzr, xzr, [x19, 256]
	str	xzr, [x19, 272]
	str	xzr, [x22, 16]
	b	.L3206
	.p2align 2,,3
.L3279:
	add	x0, sp, 192
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
	b	.L3200
	.p2align 2,,3
.L3274:
	ldp	x1, x6, [x22, 16]
	str	x6, [sp, 96]
	ldr	x0, [x23, 24]
	mov	x4, 1152921504606846975
	ldr	x5, [x23, 8]
	ldr	x3, [x20, 48]
	sub	x0, x0, x6
	sub	x1, x1, x2
	asr	x0, x0, 3
	sub	x3, x3, x5
	sub	x0, x0, #1
	asr	x3, x3, 3
	add	x0, x3, x0, lsl 6
	add	x0, x0, x1, asr 3
	cmp	x0, x4
	beq	.L3156
	ldr	x0, [x20]
	cmp	x6, x0
	beq	.L3157
.L3159:
	mov	x0, 512
.LEHB275:
	bl	_Znwm
	ldr	x1, [sp, 96]
	str	x0, [x1, -8]
	ldr	x0, [x20, 40]
	sub	x1, x0, #8
	ldr	x0, [x0, -8]
	str	x0, [x22, 8]
	str	x1, [x22, 24]
	add	x1, x0, 512
	str	x1, [x22, 16]
	add	x1, x0, 504
	str	x1, [x20, 16]
	str	x26, [x0, 504]
	b	.L3158
.L3157:
	mov	x0, x20
	mov	w2, 1
	mov	x1, 1
	bl	_ZNSt5dequeIPN7hnswlib11VisitedListESaIS2_EE17_M_reallocate_mapEmb
	ldr	x0, [x20, 40]
	str	x0, [sp, 96]
	b	.L3159
.L3156:
	adrp	x0, .LC80
	add	x0, x0, :lo12:.LC80
	bl	_ZSt20__throw_length_errorPKc
.LEHE275:
.L3278:
.LEHB276:
	bl	_ZSt20__throw_system_errori
.L3277:
	mov	w0, 1
	bl	_ZSt20__throw_system_errori
.LEHE276:
.L3272:
	adrp	x0, .LC37
	add	x0, x0, :lo12:.LC37
.LEHB277:
	bl	_ZSt20__throw_length_errorPKc
.LEHE277:
.L3217:
	mov	x21, x0
	mov	x0, x26
	bl	_ZdlPv
.L3165:
	ldr	x0, [x20]
	cbz	x0, .L3166
	ldr	x22, [x20, 72]
	ldr	x23, [x20, 40]
	add	x22, x22, 8
.L3168:
	cmp	x22, x23
	bhi	.L3280
	ldr	x0, [x20]
	bl	_ZdlPv
.L3166:
	mov	x1, x21
.L3163:
	mov	x0, x20
	mov	x20, x1
	bl	_ZdlPv
.L3181:
	mov	x0, x24
	bl	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEED1Ev
	mov	x0, x28
	bl	_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEED1Ev
	ldr	x0, [x19, 272]
	cbz	x0, .L3184
	bl	_ZdlPv
.L3184:
	ldr	x0, [x19, 192]
	cbz	x0, .L3186
	bl	_ZdlPv
.L3186:
	ldr	x0, [x19, 120]
	cbz	x0, .L3188
	bl	_ZdlPv
.L3188:
	ldr	x21, [x19, 112]
	cbz	x21, .L3189
	add	x24, x21, 48
	add	x22, x21, 16
.L3193:
	ldp	x2, x4, [x24]
	ldr	x23, [x22, 24]
	ldr	x3, [x24, 24]
	sub	x2, x2, x4
	sub	x0, x3, x23
	ldr	x1, [x22]
	asr	x0, x0, 3
	ldr	x4, [x22, 16]
	sub	x0, x0, #1
	asr	x2, x2, 3
	sub	x5, x4, x1
	add	x0, x2, x0, lsl 6
	add	x0, x0, x5, asr 3
	cbz	x0, .L3190
	sub	x4, x4, #8
	ldr	x23, [x1]
	cmp	x1, x4
	beq	.L3191
	add	x1, x1, 8
	str	x1, [x21, 16]
	cbz	x23, .L3193
.L3282:
	ldr	x0, [x23, 8]
	cbz	x0, .L3194
	bl	_ZdaPv
.L3194:
	mov	x0, x23
	bl	_ZdlPv
	b	.L3193
.L3216:
	mov	x21, x0
	b	.L3165
.L3281:
	ldr	x0, [x23], 8
	bl	_ZdlPv
.L3198:
	cmp	x22, x23
	bhi	.L3281
	ldr	x0, [x21]
	bl	_ZdlPv
.L3196:
	mov	x0, x21
	bl	_ZdlPv
.L3189:
	mov	x0, x19
	bl	_ZdlPv
	mov	x0, x20
.LEHB278:
	bl	_Unwind_Resume
.L3211:
	mov	x20, x0
	b	.L3184
.L3280:
	ldr	x0, [x23], 8
	bl	_ZdlPv
	b	.L3168
.L3212:
	mov	x20, x0
	b	.L3181
.L3208:
	ldr	x1, [sp, 160]
	add	x2, sp, 176
	mov	x19, x0
	cmp	x1, x2
	beq	.L3205
	mov	x0, x1
	bl	_ZdlPv
.L3205:
	mov	x0, x19
	bl	_Unwind_Resume
.LEHE278:
.L3276:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC88
	mov	x21, x0
	add	x1, x1, :lo12:.LC88
.LEHB279:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE279:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x21
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB280:
	bl	__cxa_throw
.LEHE280:
.L3213:
.L3271:
	mov	x20, x0
	mov	x0, x21
	bl	__cxa_free_exception
	b	.L3181
.L3273:
	mov	x0, x20
	bl	__cxa_allocate_exception
	adrp	x1, .LC87
	mov	x21, x0
	add	x1, x1, :lo12:.LC87
.LEHB281:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE281:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x21
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB282:
	bl	__cxa_throw
.LEHE282:
.L3219:
	bl	__cxa_begin_catch
.LEHB283:
	bl	__cxa_rethrow
.LEHE283:
.L3210:
	mov	x20, x0
	b	.L3186
.L3190:
	ldr	x0, [x21]
	cbz	x0, .L3196
	add	x22, x3, 8
	b	.L3198
.L3209:
	mov	x20, x0
	b	.L3188
.L3214:
	mov	x1, x0
	b	.L3163
.L3215:
	b	.L3271
.L3191:
	ldr	x0, [x21, 24]
	bl	_ZdlPv
	ldr	x0, [x21, 40]
	add	x1, x0, 8
	ldr	x0, [x0, 8]
	str	x0, [x22, 8]
	str	x1, [x22, 24]
	add	x1, x0, 512
	str	x1, [x22, 16]
	str	x0, [x21, 16]
	cbnz	x23, .L3282
	b	.L3193
.L3221:
	ldrb	w1, [sp, 200]
	mov	x19, x0
	cbz	w1, .L3205
	add	x0, sp, 192
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
	b	.L3205
.L3220:
	mov	x21, x0
	bl	__cxa_end_catch
	mov	x0, x21
	bl	__cxa_begin_catch
	ldr	x0, [x20]
	bl	_ZdlPv
	stp	xzr, xzr, [x20]
.LEHB284:
	bl	__cxa_rethrow
.LEHE284:
.L3218:
	mov	x21, x0
	bl	__cxa_end_catch
	mov	x1, x21
	b	.L3163
	.cfi_endproc
.LFE10504:
	.section	.gcc_except_table
	.align	2
.LLSDA10504:
	.byte	0xff
	.byte	0x9b
	.uleb128 .LLSDATT10504-.LLSDATTD10504
.LLSDATTD10504:
	.byte	0x1
	.uleb128 .LLSDACSE10504-.LLSDACSB10504
.LLSDACSB10504:
	.uleb128 .LEHB263-.LFB10504
	.uleb128 .LEHE263-.LEHB263
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB264-.LFB10504
	.uleb128 .LEHE264-.LEHB264
	.uleb128 .L3209-.LFB10504
	.uleb128 0
	.uleb128 .LEHB265-.LFB10504
	.uleb128 .LEHE265-.LEHB265
	.uleb128 .L3210-.LFB10504
	.uleb128 0
	.uleb128 .LEHB266-.LFB10504
	.uleb128 .LEHE266-.LEHB266
	.uleb128 .L3211-.LFB10504
	.uleb128 0
	.uleb128 .LEHB267-.LFB10504
	.uleb128 .LEHE267-.LEHB267
	.uleb128 .L3212-.LFB10504
	.uleb128 0
	.uleb128 .LEHB268-.LFB10504
	.uleb128 .LEHE268-.LEHB268
	.uleb128 .L3214-.LFB10504
	.uleb128 0
	.uleb128 .LEHB269-.LFB10504
	.uleb128 .LEHE269-.LEHB269
	.uleb128 .L3219-.LFB10504
	.uleb128 0x1
	.uleb128 .LEHB270-.LFB10504
	.uleb128 .LEHE270-.LEHB270
	.uleb128 .L3216-.LFB10504
	.uleb128 0
	.uleb128 .LEHB271-.LFB10504
	.uleb128 .LEHE271-.LEHB271
	.uleb128 .L3217-.LFB10504
	.uleb128 0
	.uleb128 .LEHB272-.LFB10504
	.uleb128 .LEHE272-.LEHB272
	.uleb128 .L3221-.LFB10504
	.uleb128 0
	.uleb128 .LEHB273-.LFB10504
	.uleb128 .LEHE273-.LEHB273
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB274-.LFB10504
	.uleb128 .LEHE274-.LEHB274
	.uleb128 .L3208-.LFB10504
	.uleb128 0
	.uleb128 .LEHB275-.LFB10504
	.uleb128 .LEHE275-.LEHB275
	.uleb128 .L3216-.LFB10504
	.uleb128 0
	.uleb128 .LEHB276-.LFB10504
	.uleb128 .LEHE276-.LEHB276
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB277-.LFB10504
	.uleb128 .LEHE277-.LEHB277
	.uleb128 .L3210-.LFB10504
	.uleb128 0
	.uleb128 .LEHB278-.LFB10504
	.uleb128 .LEHE278-.LEHB278
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB279-.LFB10504
	.uleb128 .LEHE279-.LEHB279
	.uleb128 .L3213-.LFB10504
	.uleb128 0
	.uleb128 .LEHB280-.LFB10504
	.uleb128 .LEHE280-.LEHB280
	.uleb128 .L3212-.LFB10504
	.uleb128 0
	.uleb128 .LEHB281-.LFB10504
	.uleb128 .LEHE281-.LEHB281
	.uleb128 .L3215-.LFB10504
	.uleb128 0
	.uleb128 .LEHB282-.LFB10504
	.uleb128 .LEHE282-.LEHB282
	.uleb128 .L3212-.LFB10504
	.uleb128 0
	.uleb128 .LEHB283-.LFB10504
	.uleb128 .LEHE283-.LEHB283
	.uleb128 .L3220-.LFB10504
	.uleb128 0x1
	.uleb128 .LEHB284-.LFB10504
	.uleb128 .LEHE284-.LEHB284
	.uleb128 .L3218-.LFB10504
	.uleb128 0
.LLSDACSE10504:
	.byte	0x1
	.byte	0
	.align	2
	.4byte	0

.LLSDATT10504:
	.text
	.size	_Z11build_indexPfmm, .-_Z11build_indexPfmm
	.section	.rodata._ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmb.str1.8,"aMS",@progbits,1
	.align	3
.LC90:
	.string	"Replacement of deleted elements is disabled in constructor"
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmb,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmb,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmb
	.type	_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmb, %function
_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmb:
.LFB11071:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA11071
	stp	x29, x30, [sp, -128]!
	.cfi_def_cfa_offset 128
	.cfi_offset 29, -128
	.cfi_offset 30, -120
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -112
	.cfi_offset 20, -104
	mov	x19, x0
	ldrb	w0, [x0, 456]
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -96
	.cfi_offset 22, -88
	and	w21, w3, 255
	eor	w0, w0, 1
	str	x2, [sp, 56]
	tst	w21, w0
	bne	.L3349
	mov	x20, x1
	ubfiz	x0, x2, 1, 16
	ldr	x1, [x19, 120]
	add	x0, x0, x2, uxth
	strb	wzr, [sp, 88]
	add	x0, x1, x0, lsl 4
	str	x0, [sp, 80]
	cbz	x0, .L3350
	adrp	x1, .LC36
	ldr	x22, [x1, #:lo12:.LC36]
	cbz	x22, .L3286
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L3351
.L3286:
	mov	w0, 1
	strb	w0, [sp, 88]
	cbz	w21, .L3352
	add	x0, x19, 464
	str	x0, [sp, 96]
	strb	wzr, [sp, 104]
	cbz	x22, .L3289
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L3353
.L3289:
	ldr	x21, [x19, 536]
	mov	w1, 1
	strb	w1, [sp, 104]
	add	x0, x19, 512
	cbnz	x21, .L3354
.L3290:
	add	x0, sp, 96
.LEHB285:
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
.LEHE285:
	ldr	x2, [sp, 56]
	cbz	x21, .L3355
	ldp	x4, x3, [x19, 248]
	add	x0, x19, 320
	ldr	w1, [sp, 68]
	ldr	x5, [x19, 24]
	madd	x1, x1, x5, x4
	ldr	x4, [x3, x1]
	str	x4, [sp, 72]
	str	x2, [x3, x1]
	str	x0, [sp, 112]
	strb	wzr, [sp, 120]
	cbz	x22, .L3293
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L3356
.L3293:
	mov	w3, 1
	add	x2, sp, 72
	add	x21, x19, 368
	mov	w1, 0
	mov	x0, x21
	strb	w3, [sp, 120]
	bl	_ZNSt10_HashtableImSt4pairIKmjESaIS2_ENSt8__detail10_Select1stESt8equal_toImESt4hashImENS4_18_Mod_range_hashingENS4_20_Default_ranged_hashENS4_20_Prime_rehash_policyENS4_17_Hashtable_traitsILb0ELb0ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERS1_
	mov	x0, x21
	add	x1, sp, 56
.LEHB286:
	bl	_ZNSt8__detail9_Map_baseImSt4pairIKmjESaIS3_ENS_10_Select1stESt8equal_toImESt4hashImENS_18_Mod_range_hashingENS_20_Default_ranged_hashENS_20_Prime_rehash_policyENS_17_Hashtable_traitsILb0ELb0ELb1EEELb1EEixERS2_
	mov	x1, x0
	ldr	w2, [sp, 68]
	add	x0, sp, 112
	str	w2, [x1]
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
	ldr	w1, [sp, 68]
	mov	x0, x19
	bl	_ZN7hnswlib15HierarchicalNSWIfE21unmarkDeletedInternalEj
	ldr	w2, [sp, 68]
	fmov	s0, 1.0e+0
	mov	x1, x20
	mov	x0, x19
	bl	_ZN7hnswlib15HierarchicalNSWIfE11updatePointEPKvjf
.LEHE286:
	ldrb	w0, [sp, 120]
	cbnz	w0, .L3357
.L3292:
	ldrb	w0, [sp, 104]
	cbnz	w0, .L3358
.L3295:
	ldrb	w0, [sp, 88]
	cbnz	w0, .L3359
.L3283:
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 128
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L3355:
	.cfi_restore_state
	mov	x1, x20
	mov	x0, x19
	mov	w3, -1
.LEHB287:
	bl	_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmi
.LEHE287:
	ldrb	w0, [sp, 104]
	cbz	w0, .L3295
.L3358:
	add	x0, sp, 96
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
	ldrb	w0, [sp, 88]
	cbz	w0, .L3283
.L3359:
	add	x0, sp, 80
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 128
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L3354:
	.cfi_restore_state
	ldr	x3, [x0, 16]
	add	x2, sp, 68
	mov	w1, 0
	ldr	w3, [x3, 8]
	str	w3, [sp, 68]
	bl	_ZNSt10_HashtableIjjSaIjENSt8__detail9_IdentityESt8equal_toIjESt4hashIjENS1_18_Mod_range_hashingENS1_20_Default_ranged_hashENS1_20_Prime_rehash_policyENS1_17_Hashtable_traitsILb0ELb1ELb1EEEE8_M_eraseESt17integral_constantIbLb1EERKj
	b	.L3290
	.p2align 2,,3
.L3352:
	ldr	x2, [sp, 56]
	mov	x1, x20
	mov	x0, x19
	mov	w3, -1
.LEHB288:
	bl	_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmi
.LEHE288:
	ldrb	w0, [sp, 88]
	cbz	w0, .L3283
	add	x0, sp, 80
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 128
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L3357:
	.cfi_restore_state
	add	x0, sp, 112
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
	b	.L3292
.L3353:
.LEHB289:
	bl	_ZSt20__throw_system_errori
.LEHE289:
.L3350:
	mov	w0, 1
.LEHB290:
	bl	_ZSt20__throw_system_errori
.L3351:
	bl	_ZSt20__throw_system_errori
.LEHE290:
.L3356:
.LEHB291:
	bl	_ZSt20__throw_system_errori
.LEHE291:
.L3349:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC90
	mov	x19, x0
	add	x1, x1, :lo12:.LC90
.LEHB292:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE292:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x19
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB293:
	bl	__cxa_throw
.LEHE293:
.L3310:
	ldrb	w1, [sp, 120]
	mov	x19, x0
	cbz	w1, .L3300
	add	x0, sp, 112
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
.L3300:
	ldrb	w0, [sp, 104]
	cbz	w0, .L3302
	add	x0, sp, 96
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
.L3302:
	ldrb	w0, [sp, 88]
	cbz	w0, .L3303
	add	x0, sp, 80
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
.L3303:
	mov	x0, x19
.LEHB294:
	bl	_Unwind_Resume
.L3307:
	mov	x1, x0
	mov	x0, x19
	mov	x19, x1
	bl	__cxa_free_exception
	mov	x0, x19
	bl	_Unwind_Resume
.LEHE294:
.L3309:
	mov	x19, x0
	b	.L3300
.L3308:
	mov	x19, x0
	b	.L3302
	.cfi_endproc
.LFE11071:
	.section	.gcc_except_table
.LLSDA11071:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE11071-.LLSDACSB11071
.LLSDACSB11071:
	.uleb128 .LEHB285-.LFB11071
	.uleb128 .LEHE285-.LEHB285
	.uleb128 .L3309-.LFB11071
	.uleb128 0
	.uleb128 .LEHB286-.LFB11071
	.uleb128 .LEHE286-.LEHB286
	.uleb128 .L3310-.LFB11071
	.uleb128 0
	.uleb128 .LEHB287-.LFB11071
	.uleb128 .LEHE287-.LEHB287
	.uleb128 .L3309-.LFB11071
	.uleb128 0
	.uleb128 .LEHB288-.LFB11071
	.uleb128 .LEHE288-.LEHB288
	.uleb128 .L3308-.LFB11071
	.uleb128 0
	.uleb128 .LEHB289-.LFB11071
	.uleb128 .LEHE289-.LEHB289
	.uleb128 .L3308-.LFB11071
	.uleb128 0
	.uleb128 .LEHB290-.LFB11071
	.uleb128 .LEHE290-.LEHB290
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB291-.LFB11071
	.uleb128 .LEHE291-.LEHB291
	.uleb128 .L3309-.LFB11071
	.uleb128 0
	.uleb128 .LEHB292-.LFB11071
	.uleb128 .LEHE292-.LEHB292
	.uleb128 .L3307-.LFB11071
	.uleb128 0
	.uleb128 .LEHB293-.LFB11071
	.uleb128 .LEHE293-.LEHB293
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB294-.LFB11071
	.uleb128 .LEHE294-.LEHB294
	.uleb128 0
	.uleb128 0
.LLSDACSE11071:
	.section	.text._ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmb,"axG",@progbits,_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmb,comdat
	.size	_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmb, .-_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmb
	.section	.rodata._ZNSt6vectorISt4pairIfmESaIS1_EE17_M_default_appendEm.str1.8,"aMS",@progbits,1
	.align	3
.LC91:
	.string	"vector::_M_default_append"
	.section	.text._ZNSt6vectorISt4pairIfmESaIS1_EE17_M_default_appendEm,"axG",@progbits,_ZNSt6vectorISt4pairIfmESaIS1_EE17_M_default_appendEm,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt6vectorISt4pairIfmESaIS1_EE17_M_default_appendEm
	.type	_ZNSt6vectorISt4pairIfmESaIS1_EE17_M_default_appendEm, %function
_ZNSt6vectorISt4pairIfmESaIS1_EE17_M_default_appendEm:
.LFB12895:
	.cfi_startproc
	cbz	x1, .L3384
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	mov	x3, 576460752303423487
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -48
	.cfi_offset 20, -40
	mov	x20, x1
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -32
	.cfi_offset 22, -24
	mov	x22, x0
	ldp	x0, x1, [x0]
	ldr	x2, [x22, 16]
	sub	x19, x1, x0
	sub	x2, x2, x1
	asr	x21, x19, 4
	sub	x4, x3, x21
	cmp	x20, x2, asr 4
	bhi	.L3362
	mov	x2, x1
	mov	x3, x20
	.p2align 3,,7
.L3363:
	str	wzr, [x2]
	subs	x3, x3, #1
	str	xzr, [x2, 8]
	add	x2, x2, 16
	bne	.L3363
	add	x1, x1, x20, lsl 4
	str	x1, [x22, 8]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x29, x30, [sp], 64
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L3384:
	ret
	.p2align 2,,3
.L3362:
	.cfi_def_cfa_offset 64
	.cfi_offset 19, -48
	.cfi_offset 20, -40
	.cfi_offset 21, -32
	.cfi_offset 22, -24
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	stp	x23, x24, [sp, 48]
	.cfi_offset 24, -8
	.cfi_offset 23, -16
	cmp	x4, x20
	bcc	.L3387
	cmp	x20, x21
	csel	x2, x20, x21, cs
	adds	x2, x21, x2
	bcs	.L3366
	cbnz	x2, .L3388
	mov	x23, 0
	mov	x24, 0
.L3368:
	add	x2, x24, x19
	mov	x3, x20
	.p2align 3,,7
.L3369:
	str	wzr, [x2]
	subs	x3, x3, #1
	str	xzr, [x2, 8]
	add	x2, x2, 16
	bne	.L3369
	cmp	x1, x0
	beq	.L3373
	sub	x1, x1, x0
	mov	x2, x24
	add	x1, x24, x1
	mov	x3, x0
	.p2align 3,,7
.L3374:
	ldp	x4, x5, [x3], 16
	stp	x4, x5, [x2], 16
	cmp	x2, x1
	bne	.L3374
.L3373:
	cbz	x0, .L3372
	bl	_ZdlPv
.L3372:
	add	x21, x20, x21
	str	x23, [x22, 16]
	ldp	x19, x20, [sp, 16]
	add	x21, x24, x21, lsl 4
	stp	x24, x21, [x22]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	.cfi_remember_state
	.cfi_restore 24
	.cfi_restore 23
	ldp	x29, x30, [sp], 64
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
.L3388:
	.cfi_restore_state
	cmp	x2, x3
	csel	x2, x2, x3, ls
	lsl	x23, x2, 4
.L3367:
	mov	x0, x23
	bl	_Znwm
	mov	x24, x0
	add	x23, x0, x23
	ldp	x0, x1, [x22]
	b	.L3368
.L3366:
	mov	x23, 9223372036854775792
	b	.L3367
.L3387:
	adrp	x0, .LC91
	add	x0, x0, :lo12:.LC91
	bl	_ZSt20__throw_length_errorPKc
	.cfi_endproc
.LFE12895:
	.size	_ZNSt6vectorISt4pairIfmESaIS1_EE17_M_default_appendEm, .-_ZNSt6vectorISt4pairIfmESaIS1_EE17_M_default_appendEm
	.section	.text._ZNK7hnswlib18AlgorithmInterfaceIfE20searchKnnCloserFirstEPKvmPNS_17BaseFilterFunctorE,"axG",@progbits,_ZNK7hnswlib18AlgorithmInterfaceIfE20searchKnnCloserFirstEPKvmPNS_17BaseFilterFunctorE,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNK7hnswlib18AlgorithmInterfaceIfE20searchKnnCloserFirstEPKvmPNS_17BaseFilterFunctorE
	.type	_ZNK7hnswlib18AlgorithmInterfaceIfE20searchKnnCloserFirstEPKvmPNS_17BaseFilterFunctorE, %function
_ZNK7hnswlib18AlgorithmInterfaceIfE20searchKnnCloserFirstEPKvmPNS_17BaseFilterFunctorE:
.LFB12813:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA12813
	stp	x29, x30, [sp, -64]!
	.cfi_def_cfa_offset 64
	.cfi_offset 29, -64
	.cfi_offset 30, -56
	mov	x29, sp
	ldr	x4, [x0]
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -48
	.cfi_offset 20, -40
	mov	x19, x8
	add	x8, sp, 32
	ldr	x4, [x4, 8]
	stp	xzr, xzr, [x19]
	str	xzr, [x19, 16]
.LEHB295:
	blr	x4
.LEHE295:
	ldp	x0, x2, [sp, 32]
	ldp	x3, x4, [x19]
	sub	x20, x2, x0
	sub	x1, x4, x3
	asr	x5, x20, 4
	cmp	x20, x1
	bhi	.L3427
	bcc	.L3428
.L3391:
	cmp	x2, x0
	beq	.L3392
.L3429:
	sub	x20, x20, #16
	b	.L3400
	.p2align 2,,3
.L3393:
	ldp	x0, x2, [sp, 32]
	sub	x20, x20, #16
	sub	x2, x2, #16
	str	x2, [sp, 40]
	cmp	x0, x2
	beq	.L3401
.L3400:
	ldr	x3, [x19]
	sub	x1, x2, x0
	ldr	s1, [x0]
	add	x4, x3, x20
	ldr	x5, [x0, 8]
	str	s1, [x3, x20]
	str	x5, [x4, 8]
	cmp	x1, 16
	ble	.L3393
	sub	x1, x2, #16
	ldr	s0, [x2, -16]
	sub	x1, x1, x0
	ldr	x4, [x0, 8]
	asr	x9, x1, 4
	sub	x7, x9, #1
	str	s1, [x2, -16]
	ldr	x3, [x2, -8]
	add	x7, x7, x7, lsr 63
	str	x4, [x2, -8]
	asr	x7, x7, 1
	cmp	x1, 32
	ble	.L3407
	mov	x4, 0
	b	.L3398
	.p2align 2,,3
.L3409:
	mov	x5, x2
.L3397:
	lsl	x2, x4, 4
	add	x4, x0, x2
	str	s1, [x0, x2]
	str	x5, [x4, 8]
	cmp	x1, x7
	bge	.L3394
.L3410:
	mov	x4, x1
.L3398:
	add	x2, x4, 1
	lsl	x6, x2, 1
	lsl	x2, x2, 5
	sub	x1, x6, #1
	add	x8, x0, x2
	lsl	x5, x1, 4
	ldr	s2, [x0, x2]
	add	x2, x0, x5
	ldr	s1, [x0, x5]
	fcmpe	s2, s1
	bmi	.L3413
	ldr	x5, [x8, 8]
	bgt	.L3408
	ldr	x2, [x2, 8]
	cmp	x2, x5
	bhi	.L3409
.L3408:
	fmov	s1, s2
	lsl	x2, x4, 4
	add	x4, x0, x2
	mov	x1, x6
	str	s1, [x0, x2]
	str	x5, [x4, 8]
	cmp	x1, x7
	blt	.L3410
.L3394:
	tbnz	x9, 0, .L3399
	sub	x9, x9, #2
	add	x9, x9, x9, lsr 63
	cmp	x1, x9, asr 1
	bne	.L3399
	lsl	x4, x1, 1
	lsl	x2, x1, 4
	add	x1, x4, 1
	add	x5, x0, x2
	lsl	x4, x1, 4
	add	x6, x0, x4
	ldr	s1, [x0, x4]
	ldr	x4, [x6, 8]
	str	s1, [x0, x2]
	str	x4, [x5, 8]
	.p2align 3,,7
.L3399:
	mov	x2, 0
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfmESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	ldp	x0, x2, [sp, 32]
	sub	x20, x20, #16
	sub	x2, x2, #16
	str	x2, [sp, 40]
	cmp	x0, x2
	bne	.L3400
.L3401:
	mov	x0, x2
	bl	_ZdlPv
	mov	x0, x19
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 64
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L3413:
	.cfi_restore_state
	ldr	x5, [x2, 8]
	b	.L3397
	.p2align 2,,3
.L3428:
	add	x3, x3, x20
	cmp	x4, x3
	beq	.L3391
	str	x3, [x19, 8]
	cmp	x2, x0
	bne	.L3429
.L3392:
	cbnz	x2, .L3401
	mov	x0, x19
	ldp	x19, x20, [sp, 16]
	ldp	x29, x30, [sp], 64
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L3427:
	.cfi_restore_state
	sub	x1, x5, x1, asr 4
	mov	x0, x19
.LEHB296:
	bl	_ZNSt6vectorISt4pairIfmESaIS1_EE17_M_default_appendEm
.LEHE296:
	ldp	x0, x2, [sp, 32]
	b	.L3391
	.p2align 2,,3
.L3407:
	mov	x1, 0
	b	.L3394
.L3412:
	ldr	x1, [sp, 32]
	mov	x20, x0
	cbz	x1, .L3405
	mov	x0, x1
	bl	_ZdlPv
.L3405:
	ldr	x0, [x19]
	cbz	x0, .L3406
	bl	_ZdlPv
.L3406:
	mov	x0, x20
.LEHB297:
	bl	_Unwind_Resume
.LEHE297:
.L3411:
	mov	x20, x0
	b	.L3405
	.cfi_endproc
.LFE12813:
	.section	.gcc_except_table
.LLSDA12813:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE12813-.LLSDACSB12813
.LLSDACSB12813:
	.uleb128 .LEHB295-.LFB12813
	.uleb128 .LEHE295-.LEHB295
	.uleb128 .L3411-.LFB12813
	.uleb128 0
	.uleb128 .LEHB296-.LFB12813
	.uleb128 .LEHE296-.LEHB296
	.uleb128 .L3412-.LFB12813
	.uleb128 0
	.uleb128 .LEHB297-.LFB12813
	.uleb128 .LEHE297-.LEHB297
	.uleb128 0
	.uleb128 0
.LLSDACSE12813:
	.section	.text._ZNK7hnswlib18AlgorithmInterfaceIfE20searchKnnCloserFirstEPKvmPNS_17BaseFilterFunctorE,"axG",@progbits,_ZNK7hnswlib18AlgorithmInterfaceIfE20searchKnnCloserFirstEPKvmPNS_17BaseFilterFunctorE,comdat
	.size	_ZNK7hnswlib18AlgorithmInterfaceIfE20searchKnnCloserFirstEPKvmPNS_17BaseFilterFunctorE, .-_ZNK7hnswlib18AlgorithmInterfaceIfE20searchKnnCloserFirstEPKvmPNS_17BaseFilterFunctorE
	.section	.text._ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_,"axG",@progbits,_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.type	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_, %function
_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_:
.LFB12955:
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	ldp	x24, x23, [x0]
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	mov	x21, x0
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	sub	x0, x23, x24
	stp	x27, x28, [sp, 80]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	.cfi_offset 27, -16
	.cfi_offset 28, -8
	mov	x27, x2
	asr	x0, x0, 3
	mov	x2, 1152921504606846975
	cmp	x0, x2
	beq	.L3448
	cmp	x0, 0
	mov	x19, x1
	sub	x26, x1, x24
	csinc	x1, x0, xzr, ne
	mov	x28, x3
	adds	x1, x1, x0
	bcs	.L3441
	cbnz	x1, .L3435
	mov	x25, 8
	mov	x22, 0
	mov	x20, 0
.L3440:
	ldr	s0, [x27]
	add	x0, x20, x26
	ldr	w1, [x28]
	str	s0, [x20, x26]
	str	w1, [x0, 4]
	cmp	x19, x24
	beq	.L3436
	mov	x4, x20
	mov	x3, x24
	.p2align 3,,7
.L3437:
	ldr	x5, [x3], 8
	str	x5, [x4], 8
	cmp	x3, x19
	bne	.L3437
	add	x26, x26, 8
	add	x25, x20, x26
.L3436:
	cmp	x19, x23
	beq	.L3438
	sub	x2, x23, x19
	mov	x0, x25
	mov	x1, x19
	add	x25, x25, x2
	bl	memcpy
.L3438:
	cbz	x24, .L3439
	mov	x0, x24
	bl	_ZdlPv
.L3439:
	ldp	x23, x24, [sp, 48]
	ldp	x27, x28, [sp, 80]
	stp	x20, x25, [x21]
	str	x22, [x21, 16]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L3441:
	.cfi_restore_state
	mov	x22, 9223372036854775800
.L3434:
	mov	x0, x22
	bl	_Znwm
	mov	x20, x0
	add	x22, x0, x22
	add	x25, x0, 8
	b	.L3440
.L3435:
	cmp	x1, x2
	csel	x1, x1, x2, ls
	lsl	x22, x1, 3
	b	.L3434
.L3448:
	adrp	x0, .LC42
	add	x0, x0, :lo12:.LC42
	bl	_ZSt20__throw_length_errorPKc
	.cfi_endproc
.LFE12955:
	.size	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_, .-_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.section	.text._ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_,"axG",@progbits,_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.type	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_, %function
_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_:
.LFB12957:
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	ldp	x24, x23, [x0]
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	mov	x21, x0
	stp	x19, x20, [sp, 16]
	stp	x25, x26, [sp, 64]
	sub	x0, x23, x24
	stp	x27, x28, [sp, 80]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	.cfi_offset 27, -16
	.cfi_offset 28, -8
	mov	x27, x2
	asr	x0, x0, 3
	mov	x2, 1152921504606846975
	cmp	x0, x2
	beq	.L3467
	cmp	x0, 0
	mov	x19, x1
	sub	x26, x1, x24
	csinc	x1, x0, xzr, ne
	mov	x28, x3
	adds	x1, x1, x0
	bcs	.L3460
	cbnz	x1, .L3454
	mov	x25, 8
	mov	x22, 0
	mov	x20, 0
.L3459:
	ldr	s0, [x27]
	add	x0, x20, x26
	ldr	w1, [x28]
	str	s0, [x20, x26]
	str	w1, [x0, 4]
	cmp	x19, x24
	beq	.L3455
	mov	x4, x20
	mov	x3, x24
	.p2align 3,,7
.L3456:
	ldr	x5, [x3], 8
	str	x5, [x4], 8
	cmp	x3, x19
	bne	.L3456
	add	x26, x26, 8
	add	x25, x20, x26
.L3455:
	cmp	x19, x23
	beq	.L3457
	sub	x2, x23, x19
	mov	x0, x25
	mov	x1, x19
	add	x25, x25, x2
	bl	memcpy
.L3457:
	cbz	x24, .L3458
	mov	x0, x24
	bl	_ZdlPv
.L3458:
	ldp	x23, x24, [sp, 48]
	ldp	x27, x28, [sp, 80]
	stp	x20, x25, [x21]
	str	x22, [x21, 16]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L3460:
	.cfi_restore_state
	mov	x22, 9223372036854775800
.L3453:
	mov	x0, x22
	bl	_Znwm
	mov	x20, x0
	add	x22, x0, x22
	add	x25, x0, 8
	b	.L3459
.L3454:
	cmp	x1, x2
	csel	x1, x1, x2, ls
	lsl	x22, x1, 3
	b	.L3453
.L3467:
	adrp	x0, .LC42
	add	x0, x0, :lo12:.LC42
	bl	_ZSt20__throw_length_errorPKc
	.cfi_endproc
.LFE12957:
	.size	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_, .-_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.section	.text._ZNK7hnswlib15HierarchicalNSWIfE17searchBaseLayerSTILb1ELb0EEESt14priority_queueISt4pairIfjESt6vectorIS5_SaIS5_EENS1_14CompareByFirstEEjPKvmPNS_17BaseFilterFunctorEPNS_23BaseSearchStopConditionIfEE,"axG",@progbits,_ZNK7hnswlib15HierarchicalNSWIfE17searchBaseLayerSTILb1ELb0EEESt14priority_queueISt4pairIfjESt6vectorIS5_SaIS5_EENS1_14CompareByFirstEEjPKvmPNS_17BaseFilterFunctorEPNS_23BaseSearchStopConditionIfEE,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNK7hnswlib15HierarchicalNSWIfE17searchBaseLayerSTILb1ELb0EEESt14priority_queueISt4pairIfjESt6vectorIS5_SaIS5_EENS1_14CompareByFirstEEjPKvmPNS_17BaseFilterFunctorEPNS_23BaseSearchStopConditionIfEE
	.type	_ZNK7hnswlib15HierarchicalNSWIfE17searchBaseLayerSTILb1ELb0EEESt14priority_queueISt4pairIfjESt6vectorIS5_SaIS5_EENS1_14CompareByFirstEEjPKvmPNS_17BaseFilterFunctorEPNS_23BaseSearchStopConditionIfEE, %function
_ZNK7hnswlib15HierarchicalNSWIfE17searchBaseLayerSTILb1ELb0EEESt14priority_queueISt4pairIfjESt6vectorIS5_SaIS5_EENS1_14CompareByFirstEEjPKvmPNS_17BaseFilterFunctorEPNS_23BaseSearchStopConditionIfEE:
.LFB12843:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA12843
	stp	x29, x30, [sp, -192]!
	.cfi_def_cfa_offset 192
	.cfi_offset 29, -192
	.cfi_offset 30, -184
	mov	x29, sp
	stp	x21, x22, [sp, 32]
	.cfi_offset 21, -160
	.cfi_offset 22, -152
	mov	x21, x0
	mov	x22, x3
	ldr	x0, [x0, 112]
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -176
	.cfi_offset 20, -168
	mov	x19, x8
	stp	x23, x24, [sp, 48]
	stp	x25, x26, [sp, 64]
	stp	x27, x28, [sp, 80]
	.cfi_offset 23, -144
	.cfi_offset 24, -136
	.cfi_offset 25, -128
	.cfi_offset 26, -120
	.cfi_offset 27, -112
	.cfi_offset 28, -104
	mov	x27, x2
	str	d8, [sp, 96]
	.cfi_offset 72, -96
	str	w1, [sp, 124]
.LEHB298:
	bl	_ZN7hnswlib15VisitedListPool18getFreeVisitedListEv
.LEHE298:
	ldr	w1, [sp, 124]
	mov	x28, x0
	ldr	x5, [x21, 24]
	mov	x0, x27
	ldr	x4, [x21, 232]
	ldrh	w24, [x28]
	ldr	x23, [x28, 8]
	madd	x1, x1, x5, x4
	ldr	x4, [x21, 256]
	stp	xzr, xzr, [sp, 160]
	ldr	x3, [x21, 304]
	stp	xzr, xzr, [x19]
	add	x1, x4, x1
	str	xzr, [x19, 16]
	str	xzr, [sp, 176]
	ldr	x2, [x21, 312]
.LEHB299:
	blr	x3
	ldp	x1, x0, [x19, 8]
	str	s0, [sp, 140]
	fmov	s8, s0
	cmp	x1, x0
	beq	.L3469
	ldr	w7, [sp, 124]
	fmov	s2, s0
	fmov	s1, s0
	str	s0, [x1]
	str	w7, [x1, 4]
	add	x0, x1, 8
	str	x0, [x19, 8]
.L3470:
	ldr	x3, [x19]
	sub	x2, x0, x3
	asr	x0, x2, 3
	sub	x1, x0, #2
	sub	x0, x0, #1
	add	x1, x1, x1, lsr 63
	asr	x1, x1, 1
	cmp	x0, 0
	ble	.L3471
	.p2align 3,,7
.L3474:
	lsl	x2, x1, 3
	lsl	x0, x0, 3
	add	x5, x3, x2
	add	x4, x3, x0
	ldr	s0, [x3, x2]
	fcmpe	s0, s2
	bmi	.L3524
.L3472:
	ldp	x1, x0, [sp, 168]
	fneg	s1, s1
	str	w7, [x4, 4]
	str	s2, [x4]
	str	s1, [sp, 144]
	cmp	x1, x0
	beq	.L3475
.L3549:
	ldr	w8, [sp, 124]
	add	x7, x1, 8
	str	s1, [x1]
	mov	w9, w8
	str	w8, [x1, 4]
	str	x7, [sp, 168]
.L3476:
	ldr	x0, [sp, 160]
	sub	x3, x7, x0
	asr	x1, x3, 3
	sub	x2, x1, #2
	sub	x1, x1, #1
	add	x2, x2, x2, lsr 63
	asr	x2, x2, 1
	cmp	x1, 0
	ble	.L3477
	.p2align 3,,7
.L3480:
	lsl	x3, x2, 3
	lsl	x1, x1, 3
	add	x5, x0, x3
	add	x4, x0, x1
	ldr	s0, [x0, x3]
	fcmpe	s0, s1
	bmi	.L3525
.L3478:
	str	s1, [x4]
	str	w9, [x4, 4]
	strh	w24, [x23, w8, uxtw 1]
	cmp	x0, x7
	beq	.L3481
	.p2align 3,,7
.L3483:
	ldr	s0, [x0]
	ldr	w20, [x0, 4]
	fneg	s0, s0
	fcmpe	s0, s8
	bgt	.L3481
	add	x0, sp, 160
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	ldr	x3, [x21, 24]
	uxtw	x0, w20
	ldr	x2, [x21, 240]
	mov	x20, 1
	ldr	x1, [x21, 256]
	madd	x0, x0, x3, x2
	add	x26, x1, x0
	ldrh	w25, [x1, x0]
	cbnz	x25, .L3482
	b	.L3502
	.p2align 2,,3
.L3547:
	mov	x20, x0
.L3482:
	ldr	w1, [x26, x20, lsl 2]
	sbfiz	x0, x1, 1, 32
	ldrh	w2, [x23, x0]
	str	w1, [sp, 136]
	cmp	w2, w24
	beq	.L3484
	ldr	x5, [x21, 24]
	uxtw	x1, w1
	ldr	x4, [x21, 232]
	ldp	x3, x2, [x21, 304]
	strh	w24, [x23, x0]
	madd	x1, x1, x5, x4
	mov	x0, x27
	ldr	x4, [x21, 256]
	add	x1, x4, x1
	blr	x3
.LEHE299:
	ldp	x0, x1, [x19]
	str	s0, [sp, 140]
	sub	x0, x1, x0
	cmp	x22, x0, asr 3
	bhi	.L3485
	fcmpe	s0, s8
	bmi	.L3485
.L3484:
	add	x0, x20, 1
	cmp	x25, x20
	bne	.L3547
.L3502:
	ldp	x0, x1, [sp, 160]
	cmp	x1, x0
	bne	.L3483
.L3481:
	adrp	x0, .LC36
	strb	wzr, [sp, 152]
	ldr	x20, [x21, 112]
	ldr	x1, [x0, #:lo12:.LC36]
	add	x0, x20, 80
	str	x0, [sp, 144]
	cbz	x1, .L3503
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L3548
.L3503:
	ldp	x0, x1, [x20, 16]
	mov	w2, 1
	strb	w2, [sp, 152]
	cmp	x0, x1
	beq	.L3504
	str	x28, [x0, -8]!
	str	x0, [x20, 16]
.L3505:
	add	x0, sp, 144
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
.L3508:
	ldr	x0, [sp, 160]
	cbz	x0, .L3468
	bl	_ZdlPv
.L3468:
	mov	x0, x19
	ldr	d8, [sp, 96]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x23, x24, [sp, 48]
	ldp	x25, x26, [sp, 64]
	ldp	x27, x28, [sp, 80]
	ldp	x29, x30, [sp], 192
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 28
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_restore 72
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L3524:
	.cfi_restore_state
	sub	x2, x1, #1
	ldr	w6, [x5, 4]
	str	s0, [x3, x0]
	mov	x0, x1
	add	x2, x2, x2, lsr 63
	str	w6, [x4, 4]
	asr	x1, x2, 1
	cmp	x0, 0
	bgt	.L3474
	mov	x4, x5
	fneg	s1, s1
	ldp	x1, x0, [sp, 168]
	str	w7, [x4, 4]
	str	s2, [x4]
	str	s1, [sp, 144]
	cmp	x1, x0
	bne	.L3549
.L3475:
	add	x3, sp, 124
	add	x2, sp, 144
	add	x0, sp, 160
.LEHB300:
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	ldr	x7, [sp, 168]
	ldr	w8, [sp, 124]
	ldr	w9, [x7, -4]
	ldr	s1, [x7, -8]
	b	.L3476
	.p2align 2,,3
.L3525:
	sub	x3, x2, #1
	ldr	w6, [x5, 4]
	str	s0, [x0, x1]
	mov	x1, x2
	add	x3, x3, x3, lsr 63
	str	w6, [x4, 4]
	asr	x2, x3, 1
	cmp	x1, 0
	bgt	.L3480
	mov	x4, x5
	b	.L3478
	.p2align 2,,3
.L3485:
	ldp	x2, x0, [sp, 168]
	fneg	s1, s0
	str	s1, [sp, 144]
	cmp	x2, x0
	beq	.L3488
	ldr	w8, [sp, 136]
	add	x0, x2, 8
	str	s1, [x2]
	str	w8, [x2, 4]
	str	x0, [sp, 168]
.L3489:
	ldr	x4, [sp, 160]
	sub	x3, x0, x4
	asr	x0, x3, 3
	sub	x2, x0, #2
	sub	x0, x0, #1
	add	x2, x2, x2, lsr 63
	asr	x2, x2, 1
	cmp	x0, 0
	ble	.L3490
	.p2align 3,,7
.L3493:
	lsl	x3, x2, 3
	lsl	x0, x0, 3
	add	x6, x4, x3
	add	x5, x4, x0
	ldr	s2, [x4, x3]
	fcmpe	s2, s1
	bmi	.L3526
.L3491:
	ldr	x0, [x19, 16]
	str	s1, [x5]
	str	w8, [x5, 4]
	cmp	x0, x1
	beq	.L3494
.L3550:
	ldr	s2, [sp, 140]
	add	x5, x1, 8
	ldr	w9, [sp, 136]
	str	w9, [x1, 4]
	str	s2, [x1]
	str	x5, [x19, 8]
.L3495:
	ldr	x1, [x19]
	sub	x3, x5, x1
	asr	x8, x3, 3
	sub	x0, x8, #2
	sub	x2, x8, #1
	add	x0, x0, x0, lsr 63
	asr	x0, x0, 1
	cmp	x2, 0
	ble	.L3496
	.p2align 3,,7
.L3499:
	lsl	x3, x0, 3
	lsl	x2, x2, 3
	add	x6, x1, x3
	add	x4, x1, x2
	ldr	s1, [x1, x3]
	fcmpe	s1, s2
	bmi	.L3527
.L3497:
	str	s2, [x4]
	str	w9, [x4, 4]
	cmp	x22, x8
	bcs	.L3500
	.p2align 3,,7
.L3501:
	mov	x0, x19
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	ldp	x1, x5, [x19]
	sub	x0, x5, x1
	cmp	x22, x0, asr 3
	bcc	.L3501
.L3500:
	cmp	x1, x5
	beq	.L3484
	ldr	s8, [x1]
	b	.L3484
	.p2align 2,,3
.L3526:
	sub	x3, x2, #1
	ldr	w7, [x6, 4]
	str	s2, [x4, x0]
	mov	x0, x2
	add	x3, x3, x3, lsr 63
	str	w7, [x5, 4]
	asr	x2, x3, 1
	cmp	x0, 0
	bgt	.L3493
	mov	x5, x6
	ldr	x0, [x19, 16]
	str	s1, [x5]
	str	w8, [x5, 4]
	cmp	x0, x1
	bne	.L3550
.L3494:
	add	x3, sp, 136
	add	x2, sp, 140
	mov	x0, x19
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	ldr	x5, [x19, 8]
	ldr	w9, [x5, -4]
	ldr	s2, [x5, -8]
	b	.L3495
	.p2align 2,,3
.L3527:
	sub	x3, x0, #1
	ldr	w7, [x6, 4]
	str	s1, [x1, x2]
	mov	x2, x0
	add	x3, x3, x3, lsr 63
	str	w7, [x4, 4]
	asr	x0, x3, 1
	cmp	x2, 0
	bgt	.L3499
	mov	x4, x6
	b	.L3497
	.p2align 2,,3
.L3488:
	mov	x1, x2
	add	x3, sp, 136
	add	x2, sp, 144
	add	x0, sp, 160
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE300:
	ldr	x0, [sp, 168]
	ldr	x1, [x19, 8]
	ldr	w8, [x0, -4]
	ldr	s1, [x0, -8]
	b	.L3489
.L3490:
	sub	x0, x3, #8
	add	x5, x4, x0
	b	.L3491
.L3496:
	sub	x3, x3, #8
	add	x4, x1, x3
	b	.L3497
.L3504:
	add	x21, x20, 16
	mov	x5, 1152921504606846975
	ldp	x4, x6, [x20, 48]
	ldp	x3, x22, [x21, 16]
	ldr	x1, [x20, 72]
	sub	x4, x4, x6
	sub	x1, x1, x22
	sub	x3, x3, x0
	asr	x0, x4, 3
	asr	x1, x1, 3
	sub	x1, x1, #1
	add	x0, x0, x1, lsl 6
	add	x0, x0, x3, asr 3
	cmp	x0, x5
	beq	.L3551
	ldr	x0, [x20]
	cmp	x22, x0
	beq	.L3552
.L3507:
	mov	x0, 512
.LEHB301:
	bl	_Znwm
.LEHE301:
	ldrb	w1, [sp, 152]
	str	x0, [x22, -8]
	ldr	x0, [x20, 40]
	sub	x2, x0, #8
	ldr	x0, [x0, -8]
	str	x0, [x21, 8]
	str	x2, [x21, 24]
	add	x2, x0, 512
	str	x2, [x21, 16]
	add	x2, x0, 504
	str	x2, [x20, 16]
	str	x28, [x0, 504]
	cbz	w1, .L3508
	b	.L3505
	.p2align 2,,3
.L3469:
	add	x3, sp, 124
	add	x2, sp, 140
	mov	x0, x19
.LEHB302:
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE302:
	ldr	x0, [x19, 8]
	ldr	s1, [sp, 140]
	ldr	w7, [x0, -4]
	ldr	s2, [x0, -8]
	b	.L3470
.L3552:
	mov	x0, x20
	mov	x1, 1
.LEHB303:
	bl	_ZNSt5dequeIPN7hnswlib11VisitedListESaIS2_EE17_M_reallocate_mapEmb
	ldr	x22, [x20, 40]
	b	.L3507
.L3477:
	sub	x3, x3, #8
	add	x4, x0, x3
	b	.L3478
.L3471:
	sub	x0, x2, #8
	add	x4, x3, x0
	b	.L3472
.L3551:
	adrp	x0, .LC80
	add	x0, x0, :lo12:.LC80
	bl	_ZSt20__throw_length_errorPKc
.LEHE303:
.L3548:
.LEHB304:
	bl	_ZSt20__throw_system_errori
.LEHE304:
.L3522:
	mov	x20, x0
.L3513:
	ldr	x0, [sp, 160]
	cbz	x0, .L3514
	bl	_ZdlPv
.L3514:
	ldr	x0, [x19]
	cbz	x0, .L3515
	bl	_ZdlPv
.L3515:
	mov	x0, x20
.LEHB305:
	bl	_Unwind_Resume
.LEHE305:
.L3523:
	ldrb	w1, [sp, 152]
	mov	x20, x0
	cbz	w1, .L3513
	add	x0, sp, 144
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
	b	.L3513
	.cfi_endproc
.LFE12843:
	.section	.gcc_except_table
.LLSDA12843:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE12843-.LLSDACSB12843
.LLSDACSB12843:
	.uleb128 .LEHB298-.LFB12843
	.uleb128 .LEHE298-.LEHB298
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB299-.LFB12843
	.uleb128 .LEHE299-.LEHB299
	.uleb128 .L3522-.LFB12843
	.uleb128 0
	.uleb128 .LEHB300-.LFB12843
	.uleb128 .LEHE300-.LEHB300
	.uleb128 .L3522-.LFB12843
	.uleb128 0
	.uleb128 .LEHB301-.LFB12843
	.uleb128 .LEHE301-.LEHB301
	.uleb128 .L3523-.LFB12843
	.uleb128 0
	.uleb128 .LEHB302-.LFB12843
	.uleb128 .LEHE302-.LEHB302
	.uleb128 .L3522-.LFB12843
	.uleb128 0
	.uleb128 .LEHB303-.LFB12843
	.uleb128 .LEHE303-.LEHB303
	.uleb128 .L3523-.LFB12843
	.uleb128 0
	.uleb128 .LEHB304-.LFB12843
	.uleb128 .LEHE304-.LEHB304
	.uleb128 .L3522-.LFB12843
	.uleb128 0
	.uleb128 .LEHB305-.LFB12843
	.uleb128 .LEHE305-.LEHB305
	.uleb128 0
	.uleb128 0
.LLSDACSE12843:
	.section	.text._ZNK7hnswlib15HierarchicalNSWIfE17searchBaseLayerSTILb1ELb0EEESt14priority_queueISt4pairIfjESt6vectorIS5_SaIS5_EENS1_14CompareByFirstEEjPKvmPNS_17BaseFilterFunctorEPNS_23BaseSearchStopConditionIfEE,"axG",@progbits,_ZNK7hnswlib15HierarchicalNSWIfE17searchBaseLayerSTILb1ELb0EEESt14priority_queueISt4pairIfjESt6vectorIS5_SaIS5_EENS1_14CompareByFirstEEjPKvmPNS_17BaseFilterFunctorEPNS_23BaseSearchStopConditionIfEE,comdat
	.size	_ZNK7hnswlib15HierarchicalNSWIfE17searchBaseLayerSTILb1ELb0EEESt14priority_queueISt4pairIfjESt6vectorIS5_SaIS5_EENS1_14CompareByFirstEEjPKvmPNS_17BaseFilterFunctorEPNS_23BaseSearchStopConditionIfEE, .-_ZNK7hnswlib15HierarchicalNSWIfE17searchBaseLayerSTILb1ELb0EEESt14priority_queueISt4pairIfjESt6vectorIS5_SaIS5_EENS1_14CompareByFirstEEjPKvmPNS_17BaseFilterFunctorEPNS_23BaseSearchStopConditionIfEE
	.section	.text._ZNSt6vectorISt4pairIfmESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_,"axG",@progbits,_ZNSt6vectorISt4pairIfmESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNSt6vectorISt4pairIfmESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.type	_ZNSt6vectorISt4pairIfmESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_, %function
_ZNSt6vectorISt4pairIfmESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_:
.LFB12965:
	.cfi_startproc
	stp	x29, x30, [sp, -96]!
	.cfi_def_cfa_offset 96
	.cfi_offset 29, -96
	.cfi_offset 30, -88
	mov	x29, sp
	stp	x23, x24, [sp, 48]
	.cfi_offset 23, -48
	.cfi_offset 24, -40
	ldp	x24, x23, [x0]
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -80
	.cfi_offset 20, -72
	mov	x20, x0
	stp	x21, x22, [sp, 32]
	stp	x25, x26, [sp, 64]
	sub	x0, x23, x24
	str	x27, [sp, 80]
	.cfi_offset 21, -64
	.cfi_offset 22, -56
	.cfi_offset 25, -32
	.cfi_offset 26, -24
	.cfi_offset 27, -16
	mov	x27, x2
	asr	x0, x0, 4
	mov	x2, 576460752303423487
	cmp	x0, x2
	beq	.L3571
	cmp	x0, 0
	mov	x19, x1
	sub	x26, x1, x24
	csinc	x1, x0, xzr, ne
	adds	x1, x1, x0
	bcs	.L3564
	cbnz	x1, .L3558
	mov	x25, 16
	mov	x22, 0
	mov	x21, 0
.L3563:
	add	x2, x21, x26
	ldp	x0, x1, [x27]
	stp	x0, x1, [x2]
	cmp	x19, x24
	beq	.L3559
	mov	x4, x21
	mov	x3, x24
	.p2align 3,,7
.L3560:
	ldp	x6, x7, [x3], 16
	stp	x6, x7, [x4], 16
	cmp	x3, x19
	bne	.L3560
	add	x26, x26, 16
	add	x25, x21, x26
.L3559:
	cmp	x19, x23
	beq	.L3561
	sub	x2, x23, x19
	mov	x0, x25
	mov	x1, x19
	add	x25, x25, x2
	bl	memcpy
.L3561:
	cbz	x24, .L3562
	mov	x0, x24
	bl	_ZdlPv
.L3562:
	ldp	x23, x24, [sp, 48]
	ldr	x27, [sp, 80]
	stp	x21, x25, [x20]
	str	x22, [x20, 16]
	ldp	x19, x20, [sp, 16]
	ldp	x21, x22, [sp, 32]
	ldp	x25, x26, [sp, 64]
	ldp	x29, x30, [sp], 96
	.cfi_remember_state
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 27
	.cfi_restore 25
	.cfi_restore 26
	.cfi_restore 23
	.cfi_restore 24
	.cfi_restore 21
	.cfi_restore 22
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L3564:
	.cfi_restore_state
	mov	x22, 9223372036854775792
.L3557:
	mov	x0, x22
	bl	_Znwm
	mov	x21, x0
	add	x22, x0, x22
	add	x25, x0, 16
	b	.L3563
.L3558:
	cmp	x1, x2
	csel	x1, x1, x2, ls
	lsl	x22, x1, 4
	b	.L3557
.L3571:
	adrp	x0, .LC42
	add	x0, x0, :lo12:.LC42
	bl	_ZSt20__throw_length_errorPKc
	.cfi_endproc
.LFE12965:
	.size	_ZNSt6vectorISt4pairIfmESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_, .-_ZNSt6vectorISt4pairIfmESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	.section	.text._ZNK7hnswlib15HierarchicalNSWIfE9searchKnnEPKvmPNS_17BaseFilterFunctorE,"axG",@progbits,_ZNK7hnswlib15HierarchicalNSWIfE9searchKnnEPKvmPNS_17BaseFilterFunctorE,comdat
	.align	2
	.p2align 4,,11
	.weak	_ZNK7hnswlib15HierarchicalNSWIfE9searchKnnEPKvmPNS_17BaseFilterFunctorE
	.type	_ZNK7hnswlib15HierarchicalNSWIfE9searchKnnEPKvmPNS_17BaseFilterFunctorE, %function
_ZNK7hnswlib15HierarchicalNSWIfE9searchKnnEPKvmPNS_17BaseFilterFunctorE:
.LFB12782:
	.cfi_startproc
	.cfi_personality 0x9b,DW.ref.__gxx_personality_v0
	.cfi_lsda 0x1b,.LLSDA12782
	stp	x29, x30, [sp, -288]!
	.cfi_def_cfa_offset 288
	.cfi_offset 29, -288
	.cfi_offset 30, -280
	mov	x29, sp
	stp	x19, x20, [sp, 16]
	.cfi_offset 19, -272
	.cfi_offset 20, -264
	mov	x19, x0
	stp	xzr, xzr, [x8]
	str	xzr, [x8, 16]
	str	x8, [sp, 128]
	str	x2, [sp, 144]
	add	x0, x0, 16
	ldar	x0, [x0]
	cbz	x0, .L3572
	stp	x25, x26, [sp, 64]
	.cfi_offset 26, -216
	.cfi_offset 25, -224
	mov	x0, x1
	ldr	w25, [x19, 216]
	stp	x23, x24, [sp, 48]
	.cfi_offset 24, -232
	.cfi_offset 23, -240
	mov	x23, x1
	uxtw	x20, w25
	ldr	x1, [x19, 24]
	stp	x27, x28, [sp, 80]
	.cfi_offset 28, -200
	.cfi_offset 27, -208
	mov	x28, x3
	ldr	x4, [x19, 232]
	stp	x21, x22, [sp, 32]
	.cfi_offset 22, -248
	.cfi_offset 21, -256
	ldp	x3, x2, [x19, 304]
	madd	x1, x20, x1, x4
	ldr	x4, [x19, 256]
	str	d8, [sp, 96]
	.cfi_offset 72, -192
	add	x1, x4, x1
.LEHB306:
	blr	x3
	ldr	w0, [x19, 104]
	fmov	s8, s0
	cmp	w0, 0
	ble	.L3575
	sxtw	x27, w0
	sub	w0, w0, #1
	sub	x1, x27, #2
	add	x26, x19, 448
	sub	x0, x1, x0
	sub	x27, x27, #1
	str	x0, [sp, 136]
	add	x0, x19, 440
	str	x0, [sp, 120]
	.p2align 3,,7
.L3578:
	ldr	x0, [x19, 32]
	ldr	x1, [x19, 264]
	mul	x0, x27, x0
	ldr	x1, [x1, x20, lsl 3]
	add	x20, x1, x0
	ldrh	w22, [x1, x0]
.L3749:
	ldaxr	x0, [x26]
	add	x0, x0, 1
	stlxr	w1, x0, [x26]
	cbnz	w1, .L3749
	ldr	x1, [sp, 120]
	and	x0, x22, 65535
.L3750:
	ldaxr	x2, [x1]
	add	x2, x2, x0
	stlxr	w3, x2, [x1]
	cbnz	w3, .L3750
	cbz	w22, .L3576
	sub	w22, w22, #1
	add	x0, x20, 8
	add	x20, x20, 4
	mov	w24, 0
	add	x22, x0, x22, uxtw 2
	.p2align 3,,7
.L3583:
	ldr	w21, [x20]
	ldr	x0, [x19, 8]
	uxtw	x1, w21
	cmp	x1, x0
	bhi	.L3735
	ldr	x5, [x19, 24]
	mov	x0, x23
	ldr	x4, [x19, 232]
	ldp	x3, x2, [x19, 304]
	madd	x1, x1, x5, x4
	ldr	x4, [x19, 256]
	add	x1, x4, x1
	blr	x3
.LEHE306:
	fcmpe	s0, s8
	bmi	.L3667
.L3580:
	add	x20, x20, 4
	cmp	x20, x22
	bne	.L3583
	uxtw	x20, w25
	cbnz	w24, .L3578
	.p2align 3,,7
.L3576:
	ldr	x0, [sp, 136]
	sub	x27, x27, #1
	cmp	x0, x27
	beq	.L3575
	uxtw	x20, w25
	b	.L3578
.L3575:
	stp	xzr, xzr, [sp, 192]
	str	xzr, [sp, 208]
	add	x0, x19, 40
	ldar	x0, [x0]
	orr	x0, x28, x0
	cbz	x0, .L3736
	ldr	x20, [x19, 80]
	str	w25, [sp, 164]
	ldr	x1, [sp, 144]
	ldr	x0, [x19, 112]
	cmp	x20, x1
	csel	x20, x20, x1, cs
.LEHB307:
	bl	_ZN7hnswlib15VisitedListPool18getFreeVisitedListEv
.LEHE307:
	ldr	w2, [sp, 164]
	mov	x4, x0
	ldr	x1, [x19, 24]
	str	x4, [sp, 152]
	ldr	x3, [x19, 256]
	ldrh	w24, [x0]
	mul	x2, x2, x1
	ldr	x22, [x0, 8]
	add	x1, x3, x2
	ldr	x0, [x19, 240]
	stp	xzr, xzr, [sp, 224]
	add	x0, x1, x0
	str	xzr, [sp, 240]
	stp	xzr, xzr, [sp, 256]
	str	xzr, [sp, 272]
	ldrb	w0, [x0, 2]
	tbnz	x0, 0, .L3591
	cbz	x28, .L3592
	ldr	x4, [x28]
	adrp	x0, _ZN7hnswlib17BaseFilterFunctorclEm
	add	x0, x0, :lo12:_ZN7hnswlib17BaseFilterFunctorclEm
	ldr	x4, [x4]
	cmp	x4, x0
	bne	.L3737
.L3592:
	ldr	x1, [x19, 232]
	mov	x0, x23
	ldr	x4, [x19, 304]
	add	x1, x2, x1
	ldr	x2, [x19, 312]
	add	x1, x3, x1
.LEHB308:
	blr	x4
	ldp	x1, x0, [sp, 232]
	str	s0, [sp, 172]
	fmov	s8, s0
	cmp	x1, x0
	beq	.L3738
	ldr	w7, [sp, 164]
	fmov	s1, s0
	fmov	s2, s0
	add	x21, sp, 164
	str	s0, [x1]
	add	x0, x1, 8
	str	w7, [x1, 4]
	str	x0, [sp, 232]
.L3596:
	ldr	x4, [sp, 224]
	sub	x2, x0, x4
	asr	x0, x2, 3
	sub	x1, x0, #2
	sub	x0, x0, #1
	add	x1, x1, x1, lsr 63
	asr	x1, x1, 1
	cmp	x0, 0
	ble	.L3597
.L3600:
	lsl	x3, x1, 3
	lsl	x0, x0, 3
	add	x5, x4, x3
	add	x2, x4, x0
	ldr	s0, [x4, x3]
	fcmpe	s0, s1
	bmi	.L3668
.L3598:
	fneg	s2, s2
	str	w7, [x2, 4]
	add	x0, sp, 176
	add	x27, sp, 256
	str	s1, [x2]
	mov	x1, x0
	mov	x2, x21
	str	x0, [sp, 136]
	mov	x0, x27
	str	s2, [sp, 176]
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE7emplaceIJfRjEEEvDpOT_
	b	.L3601
.L3744:
	cbz	x0, .L3730
	bl	_ZdlPv
.L3730:
	ldp	x21, x22, [sp, 32]
	.cfi_restore 22
	.cfi_restore 21
	ldp	x23, x24, [sp, 48]
	.cfi_restore 24
	.cfi_restore 23
	ldp	x25, x26, [sp, 64]
	.cfi_restore 26
	.cfi_restore 25
	ldp	x27, x28, [sp, 80]
	.cfi_restore 28
	.cfi_restore 27
	ldr	d8, [sp, 96]
	.cfi_restore 72
.L3572:
	ldp	x19, x20, [sp, 16]
	ldr	x0, [sp, 128]
	ldp	x29, x30, [sp], 288
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_restore 20
	.cfi_def_cfa_offset 0
	ret
	.p2align 2,,3
.L3667:
	.cfi_def_cfa_offset 288
	.cfi_offset 19, -272
	.cfi_offset 20, -264
	.cfi_offset 21, -256
	.cfi_offset 22, -248
	.cfi_offset 23, -240
	.cfi_offset 24, -232
	.cfi_offset 25, -224
	.cfi_offset 26, -216
	.cfi_offset 27, -208
	.cfi_offset 28, -200
	.cfi_offset 29, -288
	.cfi_offset 30, -280
	.cfi_offset 72, -192
	fmov	s8, s0
	mov	w25, w21
	mov	w24, 1
	b	.L3580
.L3591:
	mvni	v0.2s, 0x80, lsl 16
	add	x0, sp, 176
	add	x27, sp, 256
	mov	x1, x0
	add	x2, sp, 164
	str	x0, [sp, 136]
	mov	x0, x27
	str	s0, [sp, 176]
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE7emplaceIJfRjEEEvDpOT_
	mov	w0, 2139095039
	fmov	s8, w0
.L3601:
	ldp	x0, x1, [sp, 256]
	ldr	w2, [sp, 164]
	strh	w24, [x22, x2, lsl 1]
	cmp	x1, x0
	beq	.L3602
	.p2align 3,,7
.L3606:
	ldr	s0, [x0]
	ldr	w21, [x0, 4]
	fneg	s0, s0
	fcmpe	s0, s8
	bgt	.L3669
.L3603:
	mov	x0, x27
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	ldr	x3, [x19, 24]
	uxtw	x0, w21
	ldr	x2, [x19, 240]
	adrp	x4, _ZN7hnswlib17BaseFilterFunctorclEm
	ldr	x1, [x19, 256]
	add	x4, x4, :lo12:_ZN7hnswlib17BaseFilterFunctorclEm
	madd	x0, x0, x3, x2
	str	x4, [sp, 120]
	mov	x21, 1
	add	x26, x1, x0
	ldrh	w25, [x1, x0]
	cbnz	x25, .L3605
	b	.L3628
	.p2align 2,,3
.L3739:
	fcmpe	s0, s8
	bmi	.L3608
.L3607:
	add	x0, x21, 1
	cmp	x25, x21
	beq	.L3628
.L3741:
	mov	x21, x0
.L3605:
	ldr	w1, [x26, x21, lsl 2]
	sbfiz	x0, x1, 1, 32
	ldrh	w2, [x22, x0]
	str	w1, [sp, 168]
	cmp	w2, w24
	beq	.L3607
	ldr	x5, [x19, 24]
	uxtw	x1, w1
	ldr	x4, [x19, 232]
	ldp	x3, x2, [x19, 304]
	strh	w24, [x22, x0]
	madd	x1, x1, x5, x4
	mov	x0, x23
	ldr	x4, [x19, 256]
	add	x1, x4, x1
	blr	x3
.LEHE308:
	ldp	x1, x0, [sp, 224]
	str	s0, [sp, 172]
	sub	x0, x0, x1
	cmp	x20, x0, asr 3
	bls	.L3739
.L3608:
	ldp	x1, x0, [sp, 264]
	fneg	s0, s0
	str	s0, [sp, 176]
	cmp	x1, x0
	beq	.L3611
	ldr	w7, [sp, 168]
	add	x0, x1, 8
	str	s0, [x1]
	mov	w8, w7
	str	w7, [x1, 4]
	str	x0, [sp, 264]
.L3612:
	ldr	x3, [sp, 256]
	sub	x2, x0, x3
	asr	x0, x2, 3
	sub	x1, x0, #2
	sub	x0, x0, #1
	add	x1, x1, x1, lsr 63
	asr	x1, x1, 1
	cmp	x0, 0
	ble	.L3613
	.p2align 3,,7
.L3616:
	lsl	x2, x1, 3
	lsl	x0, x0, 3
	add	x5, x3, x2
	add	x4, x3, x0
	ldr	s1, [x3, x2]
	fcmpe	s1, s0
	bmi	.L3670
.L3614:
	ldr	x2, [x19, 24]
	uxtw	x7, w7
	ldr	x1, [x19, 256]
	ldr	x0, [x19, 240]
	str	w8, [x4, 4]
	madd	x7, x7, x2, x1
	str	s0, [x4]
	add	x0, x7, x0
	ldrb	w0, [x0, 2]
	tbnz	x0, 0, .L3731
	cbz	x28, .L3619
	ldr	x0, [x28]
	ldr	x2, [x0]
	ldr	x0, [sp, 120]
	cmp	x2, x0
	bne	.L3740
.L3619:
	ldp	x1, x0, [sp, 232]
	cmp	x1, x0
	beq	.L3620
	ldr	s1, [sp, 172]
	add	x2, x1, 8
	ldr	w9, [sp, 168]
	str	w9, [x1, 4]
	str	s1, [x1]
	str	x2, [sp, 232]
.L3621:
	ldr	x0, [sp, 224]
	sub	x4, x2, x0
	asr	x8, x4, 3
	sub	x1, x8, #2
	sub	x3, x8, #1
	add	x1, x1, x1, lsr 63
	asr	x1, x1, 1
	cmp	x3, 0
	ble	.L3622
	.p2align 3,,7
.L3625:
	lsl	x4, x1, 3
	lsl	x3, x3, 3
	add	x6, x0, x4
	add	x5, x0, x3
	ldr	s0, [x0, x4]
	fcmpe	s0, s1
	bmi	.L3671
.L3623:
	str	w9, [x5, 4]
	str	s1, [x5]
.L3618:
	cmp	x20, x8
	bcs	.L3626
	.p2align 3,,7
.L3627:
	add	x0, sp, 224
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	ldp	x0, x2, [sp, 224]
	sub	x1, x2, x0
	cmp	x20, x1, asr 3
	bcc	.L3627
.L3626:
	cmp	x0, x2
	beq	.L3607
	ldr	s8, [x0]
	add	x0, x21, 1
	cmp	x25, x21
	bne	.L3741
.L3628:
	ldp	x0, x1, [sp, 256]
	cmp	x0, x1
	bne	.L3606
.L3602:
	adrp	x0, .LC36
	strb	wzr, [sp, 184]
	ldr	x20, [x19, 112]
	ldr	x1, [x0, #:lo12:.LC36]
	add	x0, x20, 80
	str	x0, [sp, 176]
	cbz	x1, .L3629
	bl	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t
	cbnz	w0, .L3742
.L3629:
	ldp	x1, x0, [x20, 16]
	mov	w2, 1
	strb	w2, [sp, 184]
	cmp	x1, x0
	beq	.L3630
	ldr	x0, [sp, 152]
	str	x0, [x1, -8]!
	str	x1, [x20, 16]
.L3631:
	ldr	x0, [sp, 136]
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
.L3634:
	ldr	x0, [sp, 256]
	cbz	x0, .L3636
	bl	_ZdlPv
.L3636:
	ldr	x1, [sp, 224]
	str	xzr, [sp, 224]
	ldr	x0, [sp, 192]
	str	x1, [sp, 192]
	ldr	x1, [sp, 232]
	str	x1, [sp, 200]
	ldr	x1, [sp, 240]
	str	x1, [sp, 208]
	str	xzr, [sp, 232]
	str	xzr, [sp, 240]
	cbz	x0, .L3590
	bl	_ZdlPv
	ldr	x0, [sp, 224]
	cbz	x0, .L3590
	bl	_ZdlPv
.L3746:
	ldp	x0, x1, [sp, 192]
	ldr	x3, [sp, 144]
	sub	x2, x1, x0
	cmp	x3, x2, asr 3
	bcs	.L3734
	.p2align 3,,7
.L3743:
	add	x0, sp, 192
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
.L3590:
	ldp	x0, x1, [sp, 192]
	ldr	x3, [sp, 144]
	sub	x2, x1, x0
	cmp	x3, x2, asr 3
	bcc	.L3743
	b	.L3734
	.p2align 2,,3
.L3670:
	sub	x2, x1, #1
	ldr	w6, [x5, 4]
	str	s1, [x3, x0]
	mov	x0, x1
	add	x2, x2, x2, lsr 63
	str	w6, [x4, 4]
	asr	x1, x2, 1
	cmp	x0, 0
	bgt	.L3616
	mov	x4, x5
	b	.L3614
	.p2align 2,,3
.L3671:
	sub	x4, x1, #1
	ldr	w7, [x6, 4]
	str	s0, [x0, x3]
	mov	x3, x1
	add	x4, x4, x4, lsr 63
	str	w7, [x5, 4]
	asr	x1, x4, 1
	cmp	x3, 0
	bgt	.L3625
	mov	x5, x6
	b	.L3623
.L3740:
	ldr	x1, [x19, 248]
	mov	x0, x28
	ldr	x1, [x7, x1]
.LEHB309:
	blr	x2
.LEHE309:
	tst	w0, 255
	bne	.L3619
	.p2align 3,,7
.L3731:
	ldp	x0, x2, [sp, 224]
	sub	x8, x2, x0
	asr	x8, x8, 3
	b	.L3618
	.p2align 2,,3
.L3745:
	ldp	x2, x3, [sp, 256]
	stp	x2, x3, [x1], 16
	str	x1, [x4, 8]
.L3650:
	ldr	x0, [sp, 128]
	mov	x2, 0
	ldr	s0, [x1, -16]
	ldr	x3, [x1, -8]
	ldr	x0, [x0]
	sub	x4, x1, x0
	asr	x1, x4, 4
	sub	x1, x1, #1
	bl	_ZSt11__push_heapIN9__gnu_cxx17__normal_iteratorIPSt4pairIfmESt6vectorIS3_SaIS3_EEEElS3_NS0_5__ops14_Iter_comp_valISt4lessIS3_EEEEvT_T0_SF_T1_RT2_.isra.0
	add	x0, sp, 192
	bl	_ZNSt14priority_queueISt4pairIfjESt6vectorIS1_SaIS1_EEN7hnswlib15HierarchicalNSWIfE14CompareByFirstEE3popEv
	ldp	x0, x1, [sp, 192]
.L3734:
	cmp	x1, x0
	beq	.L3744
	ldp	x3, x1, [x19, 248]
	ldr	w2, [x0, 4]
	ldr	x4, [x19, 24]
	ldr	s0, [x0]
	madd	x2, x2, x4, x1
	ldr	x4, [sp, 128]
	ldr	x2, [x2, x3]
	str	s0, [sp, 256]
	ldp	x1, x0, [x4, 8]
	str	x2, [sp, 264]
	cmp	x1, x0
	bne	.L3745
	ldr	x20, [sp, 128]
	mov	x2, x27
	mov	x0, x20
.LEHB310:
	bl	_ZNSt6vectorISt4pairIfmESaIS1_EE17_M_realloc_insertIJS1_EEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE310:
	ldr	x1, [x20, 8]
	b	.L3650
	.p2align 2,,3
.L3611:
	ldr	x2, [sp, 136]
	add	x3, sp, 168
	mov	x0, x27
.LEHB311:
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	ldr	x0, [sp, 264]
	ldr	w7, [sp, 168]
	ldr	w8, [x0, -4]
	ldr	s0, [x0, -8]
	b	.L3612
	.p2align 2,,3
.L3669:
	ldp	x1, x0, [sp, 224]
	sub	x0, x0, x1
	cmp	x20, x0, asr 3
	bne	.L3603
	b	.L3602
	.p2align 2,,3
.L3613:
	sub	x0, x2, #8
	add	x4, x3, x0
	b	.L3614
.L3620:
	add	x3, sp, 168
	add	x2, sp, 172
	add	x0, sp, 224
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRiEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
.LEHE311:
	ldr	x2, [sp, 232]
	ldr	w9, [x2, -4]
	ldr	s1, [x2, -8]
	b	.L3621
.L3622:
	sub	x4, x4, #8
	add	x5, x0, x4
	b	.L3623
.L3668:
	sub	x3, x1, #1
	ldr	w6, [x5, 4]
	str	s0, [x4, x0]
	mov	x0, x1
	add	x3, x3, x3, lsr 63
	str	w6, [x2, 4]
	asr	x1, x3, 1
	cmp	x0, 0
	bgt	.L3600
	mov	x2, x5
	b	.L3598
.L3736:
	ldr	x3, [x19, 80]
	add	x27, sp, 256
	ldr	x0, [sp, 144]
	mov	x2, x23
	mov	w1, w25
	mov	x8, x27
	cmp	x3, x0
	mov	x5, 0
	csel	x3, x3, x0, cs
	mov	x4, 0
	mov	x0, x19
.LEHB312:
	bl	_ZNK7hnswlib15HierarchicalNSWIfE17searchBaseLayerSTILb1ELb0EEESt14priority_queueISt4pairIfjESt6vectorIS5_SaIS5_EENS1_14CompareByFirstEEjPKvmPNS_17BaseFilterFunctorEPNS_23BaseSearchStopConditionIfEE
.LEHE312:
	ldr	x1, [sp, 256]
	str	xzr, [sp, 256]
	ldr	x0, [sp, 192]
	str	x1, [sp, 192]
	ldr	x1, [sp, 264]
	str	x1, [sp, 200]
	ldr	x1, [sp, 272]
	str	x1, [sp, 208]
	str	xzr, [sp, 264]
	str	xzr, [sp, 272]
	cbz	x0, .L3590
	bl	_ZdlPv
	ldr	x0, [sp, 256]
	cbz	x0, .L3590
	bl	_ZdlPv
	b	.L3746
.L3630:
	add	x21, x20, 16
	mov	x5, 1152921504606846975
	ldp	x4, x6, [x20, 48]
	ldp	x3, x22, [x21, 16]
	ldr	x0, [x20, 72]
	sub	x4, x4, x6
	sub	x0, x0, x22
	sub	x1, x3, x1
	asr	x3, x4, 3
	asr	x0, x0, 3
	sub	x0, x0, #1
	add	x0, x3, x0, lsl 6
	add	x0, x0, x1, asr 3
	cmp	x0, x5
	beq	.L3747
	ldr	x0, [x20]
	cmp	x22, x0
	beq	.L3748
.L3633:
	mov	x0, 512
.LEHB313:
	bl	_Znwm
	ldrb	w1, [sp, 184]
	str	x0, [x22, -8]
	ldr	x0, [x20, 40]
	sub	x2, x0, #8
	ldr	x0, [x0, -8]
	str	x2, [x21, 24]
	str	x0, [x21, 8]
	add	x2, x0, 512
	str	x2, [x21, 16]
	add	x2, x0, 504
	str	x2, [x20, 16]
	ldr	x2, [sp, 152]
	str	x2, [x0, 504]
	cbz	w1, .L3634
	b	.L3631
	.p2align 2,,3
.L3748:
	mov	x0, x20
	mov	x1, 1
	bl	_ZNSt5dequeIPN7hnswlib11VisitedListESaIS2_EE17_M_reallocate_mapEmb
.LEHE313:
	ldr	x22, [x20, 40]
	b	.L3633
.L3738:
	add	x21, sp, 164
	add	x2, sp, 172
	mov	x3, x21
	add	x0, sp, 224
.LEHB314:
	bl	_ZNSt6vectorISt4pairIfjESaIS1_EE17_M_realloc_insertIJRfRjEEEvN9__gnu_cxx17__normal_iteratorIPS1_S3_EEDpOT_
	ldr	x0, [sp, 232]
	ldr	s2, [sp, 172]
	ldr	w7, [x0, -4]
	ldr	s1, [x0, -8]
	b	.L3596
.L3737:
	ldr	x2, [x19, 248]
	mov	x0, x28
	ldr	x1, [x1, x2]
	blr	x4
.LEHE314:
	tst	w0, 255
	beq	.L3591
	ldr	w2, [sp, 164]
	ldr	x0, [x19, 24]
	ldr	x3, [x19, 256]
	mul	x2, x2, x0
	b	.L3592
.L3747:
	adrp	x0, .LC80
	add	x0, x0, :lo12:.LC80
.LEHB315:
	bl	_ZSt20__throw_length_errorPKc
.LEHE315:
	.p2align 2,,3
.L3597:
	sub	x2, x2, #8
	add	x2, x4, x2
	b	.L3598
.L3742:
.LEHB316:
	bl	_ZSt20__throw_system_errori
.LEHE316:
.L3666:
	ldrb	w1, [sp, 184]
	mov	x19, x0
	cbz	w1, .L3639
	ldr	x0, [sp, 136]
	bl	_ZNSt11unique_lockISt5mutexE6unlockEv
.L3639:
	ldr	x0, [sp, 256]
	cbz	x0, .L3642
	bl	_ZdlPv
.L3642:
	ldr	x0, [sp, 224]
	cbz	x0, .L3644
	bl	_ZdlPv
.L3644:
	ldr	x0, [sp, 192]
	cbz	x0, .L3654
	bl	_ZdlPv
.L3654:
	ldr	x0, [sp, 128]
	ldr	x0, [x0]
	cbz	x0, .L3656
	bl	_ZdlPv
.L3656:
	mov	x0, x19
.LEHB317:
	bl	_Unwind_Resume
.LEHE317:
.L3662:
	mov	x19, x0
	b	.L3654
.L3735:
	mov	x0, 16
	bl	__cxa_allocate_exception
	adrp	x1, .LC85
	mov	x20, x0
	add	x1, x1, :lo12:.LC85
.LEHB318:
	bl	_ZNSt13runtime_errorC1EPKc
.LEHE318:
	adrp	x2, _ZNSt13runtime_errorD1Ev
	adrp	x1, _ZTISt13runtime_error
	mov	x0, x20
	add	x2, x2, :lo12:_ZNSt13runtime_errorD1Ev
	add	x1, x1, :lo12:_ZTISt13runtime_error
.LEHB319:
	bl	__cxa_throw
.LEHE319:
.L3663:
	mov	x19, x0
	mov	x0, x20
	bl	__cxa_free_exception
	b	.L3654
.L3664:
	mov	x19, x0
	b	.L3644
.L3665:
	mov	x19, x0
	b	.L3639
	.cfi_endproc
.LFE12782:
	.section	.gcc_except_table
.LLSDA12782:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE12782-.LLSDACSB12782
.LLSDACSB12782:
	.uleb128 .LEHB306-.LFB12782
	.uleb128 .LEHE306-.LEHB306
	.uleb128 .L3662-.LFB12782
	.uleb128 0
	.uleb128 .LEHB307-.LFB12782
	.uleb128 .LEHE307-.LEHB307
	.uleb128 .L3664-.LFB12782
	.uleb128 0
	.uleb128 .LEHB308-.LFB12782
	.uleb128 .LEHE308-.LEHB308
	.uleb128 .L3665-.LFB12782
	.uleb128 0
	.uleb128 .LEHB309-.LFB12782
	.uleb128 .LEHE309-.LEHB309
	.uleb128 .L3665-.LFB12782
	.uleb128 0
	.uleb128 .LEHB310-.LFB12782
	.uleb128 .LEHE310-.LEHB310
	.uleb128 .L3664-.LFB12782
	.uleb128 0
	.uleb128 .LEHB311-.LFB12782
	.uleb128 .LEHE311-.LEHB311
	.uleb128 .L3665-.LFB12782
	.uleb128 0
	.uleb128 .LEHB312-.LFB12782
	.uleb128 .LEHE312-.LEHB312
	.uleb128 .L3664-.LFB12782
	.uleb128 0
	.uleb128 .LEHB313-.LFB12782
	.uleb128 .LEHE313-.LEHB313
	.uleb128 .L3666-.LFB12782
	.uleb128 0
	.uleb128 .LEHB314-.LFB12782
	.uleb128 .LEHE314-.LEHB314
	.uleb128 .L3665-.LFB12782
	.uleb128 0
	.uleb128 .LEHB315-.LFB12782
	.uleb128 .LEHE315-.LEHB315
	.uleb128 .L3666-.LFB12782
	.uleb128 0
	.uleb128 .LEHB316-.LFB12782
	.uleb128 .LEHE316-.LEHB316
	.uleb128 .L3665-.LFB12782
	.uleb128 0
	.uleb128 .LEHB317-.LFB12782
	.uleb128 .LEHE317-.LEHB317
	.uleb128 0
	.uleb128 0
	.uleb128 .LEHB318-.LFB12782
	.uleb128 .LEHE318-.LEHB318
	.uleb128 .L3663-.LFB12782
	.uleb128 0
	.uleb128 .LEHB319-.LFB12782
	.uleb128 .LEHE319-.LEHB319
	.uleb128 .L3662-.LFB12782
	.uleb128 0
.LLSDACSE12782:
	.section	.text._ZNK7hnswlib15HierarchicalNSWIfE9searchKnnEPKvmPNS_17BaseFilterFunctorE,"axG",@progbits,_ZNK7hnswlib15HierarchicalNSWIfE9searchKnnEPKvmPNS_17BaseFilterFunctorE,comdat
	.size	_ZNK7hnswlib15HierarchicalNSWIfE9searchKnnEPKvmPNS_17BaseFilterFunctorE, .-_ZNK7hnswlib15HierarchicalNSWIfE9searchKnnEPKvmPNS_17BaseFilterFunctorE
	.section	.text.startup
	.align	2
	.p2align 4,,11
	.type	_GLOBAL__sub_I__Z11flat_searchPfS_mmm, %function
_GLOBAL__sub_I__Z11flat_searchPfS_mmm:
.LFB13023:
	.cfi_startproc
	stp	x29, x30, [sp, -32]!
	.cfi_def_cfa_offset 32
	.cfi_offset 29, -32
	.cfi_offset 30, -24
	mov	x29, sp
	str	x19, [sp, 16]
	.cfi_offset 19, -16
	adrp	x19, .LANCHOR1
	add	x19, x19, :lo12:.LANCHOR1
	mov	x0, x19
	bl	_ZNSt8ios_base4InitC1Ev
	mov	x1, x19
	adrp	x2, __dso_handle
	ldr	x19, [sp, 16]
	add	x2, x2, :lo12:__dso_handle
	ldp	x29, x30, [sp], 32
	.cfi_restore 30
	.cfi_restore 29
	.cfi_restore 19
	.cfi_def_cfa_offset 0
	adrp	x0, _ZNSt8ios_base4InitD1Ev
	add	x0, x0, :lo12:_ZNSt8ios_base4InitD1Ev
	b	__cxa_atexit
	.cfi_endproc
.LFE13023:
	.size	_GLOBAL__sub_I__Z11flat_searchPfS_mmm, .-_GLOBAL__sub_I__Z11flat_searchPfS_mmm
	.section	.init_array,"aw"
	.align	3
	.xword	_GLOBAL__sub_I__Z11flat_searchPfS_mmm
	.section	.rodata.str1.8
	.align	3
.LC92:
	.string	"Flat-Scalar-NoVec"
	.align	3
.LC93:
	.string	"Flat-AutoVec"
	.align	3
.LC94:
	.string	"Flat-Manual-NEON"
	.align	3
.LC95:
	.string	"Flat-NEON-AlignedHint"
	.align	3
.LC96:
	.string	"Flat-NEON-Unroll2"
	.align	3
.LC97:
	.string	"Flat-NEON-Unroll4"
	.align	3
.LC98:
	.string	"Flat-NEON-Unroll4-Prefetch"
	.align	3
.LC99:
	.string	"Flat-NEON-Unroll4-Prefetch-FixedTopK"
	.align	3
.LC100:
	.string	"Flat-Manual-SSE"
	.align	3
.LC101:
	.string	"Flat-Manual-AVX"
	.weak	_ZTSN7hnswlib14SpaceInterfaceIfEE
	.section	.rodata._ZTSN7hnswlib14SpaceInterfaceIfEE,"aG",@progbits,_ZTSN7hnswlib14SpaceInterfaceIfEE,comdat
	.align	3
	.type	_ZTSN7hnswlib14SpaceInterfaceIfEE, %object
	.size	_ZTSN7hnswlib14SpaceInterfaceIfEE, 30
_ZTSN7hnswlib14SpaceInterfaceIfEE:
	.string	"N7hnswlib14SpaceInterfaceIfEE"
	.weak	_ZTIN7hnswlib14SpaceInterfaceIfEE
	.section	.rodata._ZTIN7hnswlib14SpaceInterfaceIfEE,"aG",@progbits,_ZTIN7hnswlib14SpaceInterfaceIfEE,comdat
	.align	3
	.type	_ZTIN7hnswlib14SpaceInterfaceIfEE, %object
	.size	_ZTIN7hnswlib14SpaceInterfaceIfEE, 16
_ZTIN7hnswlib14SpaceInterfaceIfEE:
	.xword	_ZTVN10__cxxabiv117__class_type_infoE+16
	.xword	_ZTSN7hnswlib14SpaceInterfaceIfEE
	.weak	_ZTSN7hnswlib17InnerProductSpaceE
	.section	.rodata._ZTSN7hnswlib17InnerProductSpaceE,"aG",@progbits,_ZTSN7hnswlib17InnerProductSpaceE,comdat
	.align	3
	.type	_ZTSN7hnswlib17InnerProductSpaceE, %object
	.size	_ZTSN7hnswlib17InnerProductSpaceE, 30
_ZTSN7hnswlib17InnerProductSpaceE:
	.string	"N7hnswlib17InnerProductSpaceE"
	.weak	_ZTIN7hnswlib17InnerProductSpaceE
	.section	.rodata._ZTIN7hnswlib17InnerProductSpaceE,"aG",@progbits,_ZTIN7hnswlib17InnerProductSpaceE,comdat
	.align	3
	.type	_ZTIN7hnswlib17InnerProductSpaceE, %object
	.size	_ZTIN7hnswlib17InnerProductSpaceE, 24
_ZTIN7hnswlib17InnerProductSpaceE:
	.xword	_ZTVN10__cxxabiv120__si_class_type_infoE+16
	.xword	_ZTSN7hnswlib17InnerProductSpaceE
	.xword	_ZTIN7hnswlib14SpaceInterfaceIfEE
	.weak	_ZTSN7hnswlib18AlgorithmInterfaceIfEE
	.section	.rodata._ZTSN7hnswlib18AlgorithmInterfaceIfEE,"aG",@progbits,_ZTSN7hnswlib18AlgorithmInterfaceIfEE,comdat
	.align	3
	.type	_ZTSN7hnswlib18AlgorithmInterfaceIfEE, %object
	.size	_ZTSN7hnswlib18AlgorithmInterfaceIfEE, 34
_ZTSN7hnswlib18AlgorithmInterfaceIfEE:
	.string	"N7hnswlib18AlgorithmInterfaceIfEE"
	.weak	_ZTIN7hnswlib18AlgorithmInterfaceIfEE
	.section	.rodata._ZTIN7hnswlib18AlgorithmInterfaceIfEE,"aG",@progbits,_ZTIN7hnswlib18AlgorithmInterfaceIfEE,comdat
	.align	3
	.type	_ZTIN7hnswlib18AlgorithmInterfaceIfEE, %object
	.size	_ZTIN7hnswlib18AlgorithmInterfaceIfEE, 16
_ZTIN7hnswlib18AlgorithmInterfaceIfEE:
	.xword	_ZTVN10__cxxabiv117__class_type_infoE+16
	.xword	_ZTSN7hnswlib18AlgorithmInterfaceIfEE
	.weak	_ZTSN7hnswlib15HierarchicalNSWIfEE
	.section	.rodata._ZTSN7hnswlib15HierarchicalNSWIfEE,"aG",@progbits,_ZTSN7hnswlib15HierarchicalNSWIfEE,comdat
	.align	3
	.type	_ZTSN7hnswlib15HierarchicalNSWIfEE, %object
	.size	_ZTSN7hnswlib15HierarchicalNSWIfEE, 31
_ZTSN7hnswlib15HierarchicalNSWIfEE:
	.string	"N7hnswlib15HierarchicalNSWIfEE"
	.weak	_ZTIN7hnswlib15HierarchicalNSWIfEE
	.section	.rodata._ZTIN7hnswlib15HierarchicalNSWIfEE,"aG",@progbits,_ZTIN7hnswlib15HierarchicalNSWIfEE,comdat
	.align	3
	.type	_ZTIN7hnswlib15HierarchicalNSWIfEE, %object
	.size	_ZTIN7hnswlib15HierarchicalNSWIfEE, 24
_ZTIN7hnswlib15HierarchicalNSWIfEE:
	.xword	_ZTVN10__cxxabiv120__si_class_type_infoE+16
	.xword	_ZTSN7hnswlib15HierarchicalNSWIfEE
	.xword	_ZTIN7hnswlib18AlgorithmInterfaceIfEE
	.weak	_ZTVN7hnswlib17InnerProductSpaceE
	.section	.rodata._ZTVN7hnswlib17InnerProductSpaceE,"aG",@progbits,_ZTVN7hnswlib17InnerProductSpaceE,comdat
	.align	3
	.type	_ZTVN7hnswlib17InnerProductSpaceE, %object
	.size	_ZTVN7hnswlib17InnerProductSpaceE, 56
_ZTVN7hnswlib17InnerProductSpaceE:
	.xword	0
	.xword	_ZTIN7hnswlib17InnerProductSpaceE
	.xword	_ZN7hnswlib17InnerProductSpace13get_data_sizeEv
	.xword	_ZN7hnswlib17InnerProductSpace13get_dist_funcEv
	.xword	_ZN7hnswlib17InnerProductSpace19get_dist_func_paramEv
	.xword	_ZN7hnswlib17InnerProductSpaceD1Ev
	.xword	_ZN7hnswlib17InnerProductSpaceD0Ev
	.weak	_ZTVN7hnswlib15HierarchicalNSWIfEE
	.section	.rodata._ZTVN7hnswlib15HierarchicalNSWIfEE,"aG",@progbits,_ZTVN7hnswlib15HierarchicalNSWIfEE,comdat
	.align	3
	.type	_ZTVN7hnswlib15HierarchicalNSWIfEE, %object
	.size	_ZTVN7hnswlib15HierarchicalNSWIfEE, 64
_ZTVN7hnswlib15HierarchicalNSWIfEE:
	.xword	0
	.xword	_ZTIN7hnswlib15HierarchicalNSWIfEE
	.xword	_ZN7hnswlib15HierarchicalNSWIfE8addPointEPKvmb
	.xword	_ZNK7hnswlib15HierarchicalNSWIfE9searchKnnEPKvmPNS_17BaseFilterFunctorE
	.xword	_ZNK7hnswlib18AlgorithmInterfaceIfE20searchKnnCloserFirstEPKvmPNS_17BaseFilterFunctorE
	.xword	_ZN7hnswlib15HierarchicalNSWIfE9saveIndexERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
	.xword	_ZN7hnswlib15HierarchicalNSWIfED1Ev
	.xword	_ZN7hnswlib15HierarchicalNSWIfED0Ev
	.weakref	_ZL28__gthrw___pthread_key_createPjPFvPvE,__pthread_key_create
	.weakref	_ZL28__gthrw_pthread_mutex_unlockP15pthread_mutex_t,pthread_mutex_unlock
	.weakref	_ZL26__gthrw_pthread_mutex_lockP15pthread_mutex_t,pthread_mutex_lock
	.section	.rodata.cst8,"aM",@progbits,8
	.align	3
.LC36:
	.xword	_ZL28__gthrw___pthread_key_createPjPFvPvE
	.section	.rodata
	.align	3
	.set	.LANCHOR0,. + 0
.LC0:
	.word	0
	.word	1
	.word	2
	.word	3
	.word	4
	.word	5
	.word	6
	.word	7
	.type	CSWTCH.576, %object
	.size	CSWTCH.576, 80
CSWTCH.576:
	.xword	.LC92
	.xword	.LC93
	.xword	.LC94
	.xword	.LC95
	.xword	.LC96
	.xword	.LC97
	.xword	.LC98
	.xword	.LC99
	.xword	.LC100
	.xword	.LC101
.LC1:
	.word	4
	.word	8
	.word	16
	.word	32
	.word	64
	.zero	4
.LC2:
	.word	100
	.word	200
	.word	500
	.word	1000
	.word	2000
	.word	5000
	.word	10000
	.zero	4
.LC4:
	.word	100
	.word	500
	.word	1000
	.word	2000
	.word	5000
	.zero	4
.LC89:
	.string	"files/hnsw.index"
	.zero	1007
	.bss
	.align	3
	.set	.LANCHOR1,. + 0
	.type	_ZStL8__ioinit, %object
	.size	_ZStL8__ioinit, 1
_ZStL8__ioinit:
	.zero	1
	.hidden	DW.ref.__gxx_personality_v0
	.weak	DW.ref.__gxx_personality_v0
	.section	.data.DW.ref.__gxx_personality_v0,"awG",@progbits,DW.ref.__gxx_personality_v0,comdat
	.align	3
	.type	DW.ref.__gxx_personality_v0, %object
	.size	DW.ref.__gxx_personality_v0, 8
DW.ref.__gxx_personality_v0:
	.xword	__gxx_personality_v0
	.hidden	__dso_handle
	.ident	"GCC: (GNU) 10.3.1"
	.section	.note.GNU-stack,"",@progbits

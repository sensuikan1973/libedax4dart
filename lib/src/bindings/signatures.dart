// ignore_for_file: non_constant_identifier_names
// follow libedax naming

import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'structs/board.dart';
import 'structs/hint.dart';
import 'structs/move.dart';
import 'structs/move_list.dart';
import 'structs/position.dart';

// Native type is based on DLL_API of https://github.com/lavox/edax-reversi/tree/libedax.
// If you know the list, clone the repository and switch the branch, and grep "DLL_API".

typedef libedax_initialize_native_t = Int32 Function(Int32 argc, Pointer<Pointer<Uint8>> argv);
typedef libedax_terminate_native_t = Int32 Function();
typedef edax_init_native_t = Int32 Function();
typedef edax_new_native_t = Int32 Function();
// typedef edax_load_native_t = Int32 Function(Pointer<Utf8> file); // TODO: implement if you need
// typedef edax_save_native_t = Int32 Function(Pointer<Utf8> file); // TODO: implement if you need
typedef edax_undo_native_t = Int32 Function();
typedef edax_redo_native_t = Int32 Function();
typedef edax_mode_native_t = Int32 Function(Int32 mode);
typedef edax_setboard_native_t = Int32 Function(Pointer<Uint8> board);
// typedef edax_setboard_from_obj_native_t = Int32 Function(Pointer<Board> board, Int32 turn); // TODO: implement if you need
typedef edax_vmirror_native_t = Int32 Function();
// typedef edax_hmirror_native_t = Int32 Function(); // TODO: implement if you need
// typedef edax_rotate_native_t = Int32 Function(Int32 angle); // TODO: implement if you need
// typedef edax_symetry_native_t = Int32 Function(Int32 sym); // TODO: implement if you need
typedef edax_play_native_t = Int32 Function(Pointer<Uint8> moves);
// typedef edax_force_native_t = Int32 Function(Pointer<Utf8> moves); // TODO: implement if you need
// typedef edax_bench_native_t = Int32 Function(Pointer<BenchResult> result, Int32 n); // TODO: implement if you need
// typedef edax_bench_get_result_native_t = Int32 Function(Pointer<BenchResult> result); // TODO: implemen if you need
typedef edax_go_native_t = Int32 Function();
// typedef edax_hint_native_t = Int32 Function(Int32 n, Pointer<HintList> hintlist); // FIXME: implement
typedef edax_get_bookmove_native_t = Int32 Function(Pointer<MoveList> move_list);
typedef edax_get_bookmove_with_position_native_t = Int32 Function(
    Pointer<MoveList> move_list, Pointer<Position> position);
typedef edax_hint_prepare_native_t = Int32 Function(Pointer<MoveList> exclude_list);
typedef edax_hint_next_native_t = Int32 Function(Pointer<Hint> hint);
typedef edax_hint_next_no_multipv_depth_native_t = Int32 Function(Pointer<Hint> hint);
typedef edax_stop_native_t = Int32 Function();
typedef edax_version_native_t = Int32 Function();
typedef edax_move_native_t = Int32 Function(Pointer<Uint8> move);
typedef edax_opening_native_t = Pointer<Utf8> Function();
// typedef edax_ouverture_native_t = Pointer<Utf8> Function(); // TODO: implement if you need
// typedef edax_book_store_native_t = Int32 Function(); // TODO: implement if you need
typedef edax_book_on_native_t = Int32 Function();
typedef edax_book_off_native_t = Int32 Function();
typedef edax_book_randomness_native_t = Int32 Function(Int32 randomness);
// typedef edax_book_depth_native_t = Int32 Function(Int32 depth); // TODO: implement if you need
// typedef edax_book_new_native_t = Int32 Function(Int32 level, Int32 depth); // TODO: implement if you need
// typedef edax_book_load_native_t = Int32 Function(Pointer<Utf8> book_file); // TODO: implement if you need
// typedef edax_book_save_native_t = Int32 Function(Pointer<Utf8> book_file); // TODO: implement if you need
// typedef edax_book_import_native_t = Int32 Function(Pointer<Utf8> import_file); // TODO: implement if you need
// typedef edax_book_export_native_t = Int32 Function(Pointer<Utf8> export_file); // TODO: implement if you need
// typedef edax_book_merge_native_t = Int32 Function(Pointer<Utf8> book_file); // TODO: implement if you need
// typedef edax_book_fix_native_t = Int32 Function(); // TODO: implement if you need
// typedef edax_book_negamax_native_t = Int32 Function(); // TODO: implement if you need
// typedef edax_book_correct_native_t = Int32 Function(); // TODO: implement if you need
// typedef edax_book_prune_native_t = Int32 Function(); // TODO: implement if you need
// typedef edax_book_subtree_native_t = Int32 Function(); // TODO: implement if you need
typedef edax_book_show_native_t = Int32 Function(Pointer<Position> position);
// typedef edax_book_info_native_t = Int32 Function(Pointer<Book> book);
// typedef edax_book_verbose_native_t = Int32 Function(Int32 book_verbosity); // TODO: implement if you need
// typedef edax_book_add_native_t = Int32 Function(Pointer<Utf8> base_file); // TODO: implement if you need
// typedef edax_book_check_native_t = Int32 Function(Pointer<Utf8> base_file); // TODO: implement if you need
// typedef edax_book_extract_native_t = Int32 Function(Pointer<Utf8> base_file); // TODO: implement if you need
// typedef edax_book_deviate_native_t = Int32 Function(Int32 relative_error, Int32 absolute_error); // TODO: implement if you need
// typedef edax_book_enhance_native_t = Int32 Function(Int32 midgame_error, Int32 endcut_error); // TODO: implement if you need
// typedef edax_book_fill_native_t = Int32 Function(Int32 fill_depth); // TODO: implement if you need
// typedef edax_book_play_native_t = Int32 Function(); // TODO: implement if you need
// typedef edax_book_deepen_native_t = Int32 Function(); // NOTE: don't work at edax v4.4
// typedef edax_book_feed_hash_native_t = Int32 Function(); // TODO: implement if you need
// typedef edax_base_problem_native_t = Int32 Function(
//     Pointer<Utf8> base_file, Int32 n_empties, Pointer<Utf8> problem_file); // TODO: implement if you need
// typedef edax_base_tofen_native_t = Int32 Function(Pointer<Utf8> base_file, Int32 n_empties, Pointer<Utf8> problem_file); // TODO: implement if you need
// typedef edax_base_correct_native_t = Int32 Function(Pointer<Utf8> base_file, Int32 n_empties); // TODO: implement if you need
// typedef edax_base_complete_native_t = Int32 Function(Pointer<Utf8> base_file); // TODO: implement if you need
// typedef edax_base_convert_native_t = Int32 Function(Pointer<Utf8> base_file_from, Pointer<Utf8> base_file_to); // TODO: implement if you need
// typedef edax_base_unique_native_t = Int32 Function(Pointer<Utf8> base_file_from, Pointer<Utf8> base_file_to); // TODO: implement if you need
typedef edax_set_option_native_t = Int32 Function(Pointer<Uint8> option_name, Pointer<Uint8> val);
typedef edax_get_moves_native_t = Pointer<Uint8> Function(Pointer<Uint8> str);
typedef edax_is_game_over_native_t = Int32 Function();
typedef edax_can_move_native_t = Int32 Function();
typedef edax_get_last_move_native_t = Int32 Function(Pointer<Move> move);
typedef edax_get_board_native_t = Int32 Function(Pointer<Board> board);
typedef edax_get_current_player_native_t = Int32 Function();
typedef edax_get_disc_native_t = Int32 Function(Int32 color);
typedef edax_get_mobility_count_native_t = Int32 Function(Int32 color);

typedef bit_count_native_t = Int32 Function(Uint64 b);
typedef first_bit_native_t = Int32 Function(Uint64 b);
typedef last_bit_native_t = Int32 Function(Uint64 b);

typedef get_moves_native_t = Int32 Function(Uint64 p, Uint64 o);
typedef can_move_native_t = bool Function(Uint64 p, Uint64 o);

import 'package:flutter/material.dart';

class GiftItem {
  final String name, iconUrl, emoji;
  final int gems;
  const GiftItem(this.name, this.gems, {this.iconUrl = '', this.emoji = '🎁'});
}

final Map<String, List<GiftItem>> giftCategories = {
  'Hot': [
    const GiftItem('Champagne', 50, emoji: '🍾', iconUrl: 'https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?w=100'),
    const GiftItem('Loving Girl', 900, emoji: '💃', iconUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=100'),
  ],
  'Lucky': [const GiftItem('Mystery Box', 360, emoji: '🎁')],
  'Svip': [],
  'Intimacy': [
    const GiftItem('In My Hand', 300, emoji: '🤝'),
    const GiftItem('Kiss', 180, emoji: '💋'),
  ],
  'Wealth': [const GiftItem('Cruise Eve', 3700, emoji: '🚢')],
  'Festival': [const GiftItem('Puppy', 180, emoji: '🐶')],
  'Bag': [const GiftItem('Rose', 20, emoji: '🌹')],
};

class Host {
  final String name, pic, cat, tag, flag, status;
  final int id;
  const Host({required this.name, required this.pic, required this.cat, required this.tag, required this.flag, required this.status, required this.id});
}

class PartyRoom {
  final String title, hostName, avatar, membersCount;
  final int onlineCount;
  const PartyRoom({required this.title, required this.hostName, required this.avatar, required this.membersCount, required this.onlineCount});
}

final List<PartyRoom> mockPartyRooms = [
  const PartyRoom(title: 'কেমন আছো সবাই 😍', hostName: 'Beauty', avatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200', membersCount: '12', onlineCount: 9517),
  const PartyRoom(title: 'Mahfil a isha 💖', hostName: 'Mahfil', avatar: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200', membersCount: '10', onlineCount: 13589),
];

class FloatingChatMsg {
  final String id, user, text;
  FloatingChatMsg(this.user, this.text) : id = UniqueKey().toString();
}
